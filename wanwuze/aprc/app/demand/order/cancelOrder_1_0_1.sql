-- ##Title app-采购-取消订单申请
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-取消订单申请
-- ##CallType[ExSql]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##input reason string[500] NOTNULL;取消订单理由，必填

set @Flag1 = (select case when (accept_status = 0 and supply_done_flag = 0) then '1' else '0' end
              from coz_order
              where guid = '{orderGuid}')
;
set @Flag2 = (select case
                         when not exists(select 1
                                         from coz_order_cancel
                                         where order_guid = '{orderGuid}'
                                           and cancel_user_id = '{curUserId}'
                                           and del_flag = '0') then '1'
                         else '0' end
              from coz_order
              where guid = '{orderGuid}')
;
set @Flag3 = (select case
                         when (not exists(select 1
                                          from coz_order
                                          where parent_guid = '{orderGuid}'
                                            and del_flag = '0'
                                            and supply_done_flag = '1') and not exists(select 1
                                                                                       from coz_order
                                                                                       where guid = (select parent_guid from coz_order where GUID = '{orderGuid}')
                                                                                         and del_flag = '0'
                                                                                         and supply_done_flag = '1'))
                             then '1'
                         else '0' end)
;
set @Flag4 = (select case
                         when (exists(select 1
                                      from coz_order_judge
                                      where order_guid = '{orderGuid}'
                                        and del_flag = '0'
                                        and result <> '3')) then '0'
                         else '1' end)
;
set @parentCancelOrderGuid = uuid()
;
set @childCancelOrderGuid = uuid()
;
set @parentOrderJudgeGuid = uuid()
;
set @childOrderJudgeGuid = uuid()
;
insert into coz_order_cancel(guid, order_guid, cancel_user_id, cancel_object, reason, biz_rule_type1, biz_rule_type21,
                             refund_pay_read_flag, refund_pay_status, del_flag, create_by, create_time, update_by,
                             update_time, refund_fee)
select case when (t.guid = '{orderGuid}') then @parentCancelOrderGuid else @childCancelOrderGuid end
     , t.guid
     , '{curUserId}'
     , case when (t.guid = '{orderGuid}') then '1' else '3' end
     , case when (t.guid = '{orderGuid}') then '{reason}' else '关联订单取消，导致同步取消本订单' end
     , 'c9b596d4-7374-11ec-a478-0242ac120003'
     , 'c9b59b73-7374-11ec-a478-0242ac120003'
     , '0'
     , '0'
     , '0'
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
     , t.pay_fee
from coz_order t
where (t.guid = '{orderGuid}' or parent_guid = '{orderGuid}' or
       parent_guid in (select guid from coz_order where parent_guid = '{orderGuid}'))
  and @Flag1 = '1'
  and @Flag2 = '1'
  and @Flag3 = '1'
  and @Flag4 = '1'
;
insert into coz_order_judge(guid, order_guid, biz_guid, biz_type, user_type, result, del_flag, create_by, create_time,
                            update_by, update_time)
select @parentOrderJudgeGuid
     , t.guid
     , @parentCancelOrderGuid
     , '1'
     , '1'
     , '0'
     , 0
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_order t
where (t.guid = '{orderGuid}')
  and @Flag1 = '1'
  and @Flag2 = '1'
  and @Flag3 = '1'
  and @Flag4 = '1'
;
insert into coz_order_judge(guid, order_guid, biz_guid, biz_type, user_type, result, del_flag, create_by, create_time,
                            update_by, update_time)
select @childOrderJudgeGuid
     , t.guid
     , @childCancelOrderGuid
     , '1'
     , '1'
     , '0'
     , 0
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_order t
where (parent_guid = '{orderGuid}' or parent_guid in (select guid from coz_order where parent_guid = '{orderGuid}'))
  and @Flag1 = '1'
  and @Flag2 = '1'
  and @Flag3 = '1'
  and @Flag4 = '1'
;
insert into coz_order_operation_log(guid, order_guid, last_status, status, operate_object, remark, create_by,
                                    create_time)
select uuid()
     , t.guid
     , ifnull((select status from coz_order_operation_log where order_guid = t.guid order by create_time desc limit 1),
              '0')
     , '1'
     , '0'
     , ''
     , '0'
     , now()
from coz_order t
where (parent_guid = '{orderGuid}' or parent_guid in (select guid from coz_order where parent_guid = '{orderGuid}'))
  and @Flag1 = '1'
  and @Flag2 = '1'
  and @Flag3 = '1'
  and @Flag4 = '1'
;
insert into coz_order_operation_log(guid, order_guid, last_status, status, operate_object, remark, create_by,
                                    create_time)
select uuid()
     , '{orderGuid}'
     , ifnull(
        (select status from coz_order_operation_log where order_guid = '{orderGuid}' order by create_time desc limit 1),
        '0')
     , '1'
     , '1'
     , ''
     , '{curUserId}'
     , now()
from coz_order t
where t.guid = '{orderGuid}'
  and @Flag1 = '1'
  and @Flag2 = '1'
  and @Flag3 = '1'
  and @Flag4 = '1'
;
# 组织(服务)模块3.0相关,记录品类交易状态 -- 开始  --
set @statisticBizGuidMode2 = '';
# 需方对接专员guid
set @demandSysUserGuid = '';
# 供方用户guid
set @supplyUserGuid = '';
# 供方对接专员guid
set @supplySysUserGuid = '';
set @catMode = 0;

select t2.category_mode, t1.supply_user_id
into @catMode,@supplyUserGuid
from coz_order t1
         inner join coz_demand_request t2 on t1.request_guid = t2.guid
where t1.guid = '{orderGuid}';

# 查询交易模式下上一状态业务guid,仅交易模式下,需方才可以取消订单
select '{orderGuid}' as bizGuid
into @statisticBizGuidMode2
where @catMode = 2;

# 查询需方用户的对接专员
select user_guid as sysUserGuid
into @demandSysUserGuid
from coz_server3_sys_user_dj_bind
where binded_user_id = '{curUserId}'
  and user_type = '1';

# 查询供方用户的对接专员
select user_guid as sysUserGuid
into @supplySysUserGuid
from coz_server3_sys_user_dj_bind
where binded_user_id = @supplyUserGuid
  and user_type = '2';

# 交易模式:更新品类交易状态为需方取消订单--父订单,仅交易模式有该状态
update coz_server3_cate_dealstatus_statistic
set biz_guid            = @parentCancelOrderGuid
  , dstatus             = 216
  , update_time=now()
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
where biz_guid = '{orderGuid}'
  and @Flag1 = '1'
  and @Flag2 = '1'
  and @Flag3 = '1'
  and @Flag4 = '1'
  and @catMode = 2
;
# 交易模式:更新品类交易状态为需方取消订单--子订单,仅交易模式有该状态
update coz_server3_cate_dealstatus_statistic
set biz_guid            = @childCancelOrderGuid
  , dstatus             = 216
  , update_time=now()
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
where biz_guid = '{orderGuid}'
  and @Flag1 = '1'
  and @Flag2 = '1'
  and @Flag3 = '1'
  and @Flag4 = '1'
  and @catMode = 2
;

# 组织(服务)模块3.0相关,记录品类交易状态 -- 结束  --

select case when (@Flag1 = '1' and @Flag2 = '1' and @Flag3 = '1' and @Flag4 = '1') then '1' else '0' end as cancelFlag
     , case
           when (@Flag1 = '1' and @Flag2 = '1' and @Flag3 = '1' and @Flag4 = '1') then ''
           when (@Flag4 = '0') then '订单处于交易仲裁，停止操作'
           else '供方已经处理完成或关联订单供方已经处理，不可取消' end                                    as notOkReason