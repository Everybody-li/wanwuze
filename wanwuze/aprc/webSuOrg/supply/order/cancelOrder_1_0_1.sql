-- ##Title web-供应-取消订单申请
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-供应-取消订单申请
-- ##CallType[ExSql]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;需方用户id，必填
-- ##input reason string[500] NOTNULL;取消订单理由，必填

set @Flag1 = (select case when (accept_status = 0 and supply_done_flag = 0) then '1' else '0' end
              from coz_order
              where guid = '{orderGuid}')
;
set @Flag2 = (select case
                         when not exists(select 1
                                         from coz_order_cancel
                                         where order_guid = '{orderGuid}'
                                           and cancel_user_id = '{curUserId}') then '1'
                         else '0' end)
;
set @Flag3 = (select case
                         when (exists(select 1
                                      from coz_order_judge
                                      where order_guid = '{orderGuid}'
                                        and del_flag = '0'
                                        and result <> '3')) then '0'
                         else '1' end)
;
set @parentguid = (select parent_guid
                   from coz_order
                   where guid = '{orderGuid}')
;
set @parentOrderCancelGuid = uuid()
;
set @childOrderCancelGuid = uuid()
;
set @parentOrderJudgeGuid = uuid()
;
set @childOrderJudgeGuid = uuid()
;
insert into coz_order_cancel(guid, order_guid, cancel_user_id, cancel_object, reason, biz_rule_type1, biz_rule_type21,
                             refund_pay_read_flag, refund_pay_status, del_flag, create_by, create_time, update_by,
                             update_time, refund_fee)
select case when (t.guid = '{orderGuid}') then @parentOrderCancelGuid else @childOrderCancelGuid end
     , t.guid
     , '{curUserId}'
     , case when (t.guid = '{orderGuid}') then '2' else '3' end
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
where (t.guid = '{orderGuid}' or t.guid = @parentguid or parent_guid = '{orderGuid}' or
       parent_guid in (select guid from coz_order where parent_guid = '{orderGuid}'))
  and @Flag1 = '1'
  and @Flag2 = '1'
  and @Flag3 = '1'
;
insert into coz_order_judge(guid, order_guid, biz_guid, biz_type,supply_read_flag, user_type, result, del_flag, create_by, create_time,
                            update_by, update_time)
select @parentOrderJudgeGuid
     , t.guid
     , @parentOrderCancelGuid
     , '1'
     , '1'
     , '2'
     , '0'
     , '0'
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_order t
where (t.guid = '{orderGuid}')
  and @Flag1 = '1'
  and @Flag2 = '1'
  and @Flag3 = '1'
;
insert into coz_order_judge(guid, order_guid, biz_guid, biz_type,supply_read_flag, user_type, result, del_flag, create_by, create_time,
                            update_by, update_time)
select UUID()
     , t.guid
     , @childOrderJudgeGuid
     , '1'
     , '1'
     , '2'
     , '0'
     , '0'
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_order t
where (parent_guid = '{orderGuid}' or t.guid = @parentguid or
       parent_guid in (select guid from coz_order where parent_guid = '{orderGuid}'))
  and @Flag1 = '1'
  and @Flag2 = '1'
  and @Flag3 = '1'
;
insert into coz_order_operation_log(guid, order_guid, last_status, status, operate_object, remark, create_by,
                                    create_time)
select uuid()
     , t.guid
     , ifnull((select status from coz_order_operation_log where order_guid = t.guid order by create_time desc limit 1),
              '0')
     , '2'
     , '2'
     , ''
     , '{curUserId}'
     , now()
from coz_order t
where (parent_guid = '{orderGuid}' or t.guid = @parentguid or
       parent_guid in (select guid from coz_order where parent_guid = '{orderGuid}'))
  and @Flag1 = '1'
  and @Flag2 = '1'
  and @Flag3 = '1'
;
insert into coz_order_operation_log(guid, order_guid, last_status, status, operate_object, remark, create_by,
                                    create_time)
select uuid()
     , '{orderGuid}'
     , ifnull(
        (select status from coz_order_operation_log where order_guid = '{orderGuid}' order by create_time desc limit 1),
        '0')
     , '2'
     , '2'
     , ''
     , '{curUserId}'
     , now()
from coz_order t
where t.guid = '{orderGuid}'
  and @Flag1 = '1'
  and @Flag2 = '1'
  and @Flag3 = '1'
;

# 组织(服务)模块3.0相关,记录品类交易状态 -- 开始  --
set @demandSysUserGuid = '';
set @supplySysUserGuid = '';

# 查询需方用户的对接专员
select t2.user_guid as sysUserGuid
into @demandSysUserGuid
from coz_server3_cate_dealstatus_statistic t1
         inner join
     coz_server3_sys_user_dj_bind t2
     on t1.demand_user_id = t2.binded_user_id
where t1.biz_guid = '{orderGuid}'
  and t1.del_flag = '0'
  and t2.user_type = '1';

# 查询供方用户的对接专员
select t2.user_guid as sysUserGuid
into @supplySysUserGuid
from coz_server3_sys_user_dj_bind t2
where binded_user_id = '{curUserId}'
  and t2.user_type = '2';

# 交易模式:更新品类交易状态为供方取消订单--父订单
update coz_server3_cate_dealstatus_statistic
set biz_guid            = @parentOrderCancelGuid
  , update_time=now()
  , dstatus             = 215
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
where biz_guid = '{orderGuid}'
  and @flag1 = '1'
  and @flag2 = '1'
;


# 组织(服务)模块3.0相关,记录品类交易状态 -- 结束  --

select case when (@Flag1 = '1' and @Flag2 = '1' and @Flag3 = '1') then '1' else '0' end as cancelFlag
     , case
           when (@Flag1 = '1' and @Flag2 = '1' and @Flag3 = '1') then ''
           when (@Flag3 = '0') then '订单处于交易仲裁，停止操作'
           else '供方已经处理完成或关联订单供方已经处理，不可取消' end                   as notOkReason