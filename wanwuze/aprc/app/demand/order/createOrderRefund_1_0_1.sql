-- ##Title app-采购-申请退货
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-申请退货
-- ##CallType[ExSql]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input reason string[500] NOTNULL;取消订单理由，必填
-- ##input proveImgs string[500] NOTNULL;退货证明图片，多个逗号隔开，必填
-- ##input bizRuleType21 char[36] NOTNULL;退货裁决规则guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @Flag1 = (select case when (accept_status = 0 and supply_done_flag = 1) then '1' else '0' end
              from coz_order
              where guid = '{orderGuid}')
;
set @Flag2 = (select case
                         when not exists(select 1
                                         from coz_order_judge
                                         where order_guid = '{orderGuid}'
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
                                            and supply_done_flag = '0') and not exists(select 1
                                                                                       from coz_order
                                                                                       where guid = (select parent_guid from coz_order where guid = '{orderGuid}')
                                                                                         and del_flag = 0
                                                                                         and supply_done_flag = '0'))
                             then '1'
                         else '0' end)
;
set @parentguid = '';
#订单供方用户id
set @supplyUserId = '';
select parent_guid, supply_user_id
into @parentguid,@supplyUserId
from coz_order
where guid = '{orderGuid}';
# 订单退款guid
set @refundorderguid = uuid()
;
set @refundJudgeGuid = uuid()
;
set @childCancelJudgeGuid = uuid()
;
# 关联子订单取消guid
set @childCancelguid = uuid()
;
insert into coz_order_refund(guid, order_guid, reason, biz_rule_type21, refund_fee, prove_imgs, prove_time, del_flag,
                             create_by, create_time, update_by, update_time)
select @refundorderguid
     , '{orderGuid}'
     , '{reason}'
     , '{bizRuleType21}'
     , pay_fee
     , '{proveImgs}'
     , now()
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
;

insert into coz_order_judge(guid, order_guid, biz_guid, biz_type, user_type, result, del_flag, create_by, create_time,
                            update_by, update_time)
select @refundJudgeGuid
     , t.guid
     , @refundorderguid
     , '2'
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
;
insert into coz_order_operation_log(guid, order_guid, last_status, status, operate_object, remark, create_by,
                                    create_time)
select uuid()
     , '{orderGuid}'
     , ifnull(
        (select status from coz_order_operation_log where order_guid = '{orderGuid}' order by create_time desc limit 1),
        '0')
     , '6'
     , '1'
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
select user_guid as sysUserGuid
into @demandSysUserGuid
from coz_server3_sys_user_dj_bind
where binded_user_id = '{curUserId}'
  and user_type = '1';

# 查询供方用户的对接专员
select user_guid as sysUserGuid
into @supplySysUserGuid
from coz_server3_sys_user_dj_bind
where binded_user_id = @supplyUserId
  and user_type = '2';

# 交易模式:更新品类交易状态为需方申请退货--,父订单--仅交易模式有该状态
update coz_server3_cate_dealstatus_statistic
set biz_guid            = @refundorderguid
,update_time=now()
  , dstatus             = 218
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
where biz_guid = '{orderGuid}'
  and @Flag1 = '1'
  and @Flag2 = '1'
  and @Flag3 = '1'
;
# 交易模式:更新品类交易状态为需方申请退货--,-子订单-自动取消-仅交易模式有该状态
update coz_server3_cate_dealstatus_statistic
set biz_guid            = @childCancelguid
,update_time=now()
  , dstatus             = 215
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
where biz_guid = '{orderGuid}'
  and @Flag1 = '1'
  and @Flag2 = '1'
  and @Flag3 = '1'
;
# 组织(服务)模块3.0相关,记录品类交易状态 -- 结束  --
