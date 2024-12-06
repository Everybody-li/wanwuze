-- ##Title app-供应-退货供方手工验收不通过
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-退货供方手工验收不通过
-- ##CallType[ExSql]

-- ##input bizRuleType22Guid char[36] NOTNULL;退货验收规则guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input orderRefundGuid char[36] NOTNULL;订单退款guid，必填
-- ##input supplyNotAcceptReason string[50] NOTNULL;供方验收不通过事由，必填
-- ##input supplyAcceptProve string[600] NOTNULL;供方退货验收证明（不通过证明）图片，多个逗号分隔，必填

insert into coz_order_operation_log(guid,order_guid,last_status,status,operate_object,remark,create_by,create_time)
select
uuid()
,'{orderGuid}'
,ifnull((select status from coz_order_operation_log where order_guid='{orderGuid}' order by create_time desc limit 1),'0')
,'8'
,'2'
,''
,'{curUserId}'
,now()
;
update coz_order_refund
set supply_accept_way=1
,supply_accept=2
,supply_accept_user_id='{userId}'
,supply_accept_time=now()
,supply_not_accept_reason='{supplyNotAcceptReason}'
,supply_accept_prove='{supplyAcceptProve}'
,update_by='{curUserId}'
,update_time=now()
where guid='{orderRefundGuid}' and supply_accept=0 and supply_accept_way=0
;