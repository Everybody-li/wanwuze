-- ##Title app-采购-提交退货证明
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-提交退货证明
-- ##CallType[ExSql]

-- ##input bizRuleType23Guid char[36] NOTNULL;实物退货退款规则guid，必填
-- ##input orderRefundGuid char[36] NOTNULL;订单退货guid，必填
-- ##input proveLogisticImgs string[600] NOTNULL;退货证明图片，多个逗号隔开，必填
-- ##input proveSupplySignDate string[19] NOTNULL;需方提供的供方签收日期，必填
-- ##input proveSupplySignImgs string[600] NOTNULL;需方提供的供方签收证明图片，多个逗号隔开，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_order_operation_log(guid,order_guid,last_status,status,operate_object,remark,create_by,create_time)
select
uuid()
,order_guid
,ifnull((select status from coz_order_operation_log where order_guid=t.order_guid order by create_time desc limit 1),'0')
,'7'
,'2'
,''
,'{curUserId}'
,now()
from
coz_order_refund t
where 
guid='{orderRefundGuid}' and supply_accept_way='0' and supply_accept='0'
;
update coz_order_refund
set biz_rule_type23='{bizRuleType23Guid}'
,prove_logistic_img='{proveLogisticImgs}'
,prove_supply_sign_date='{proveSupplySignDate}'
,prove_supply_sign_imgs='{proveSupplySignImgs}'
,demand_refund_goods_opflag='2'
,demand_refund_goods_opway='1'
,prove_logistic_time=now()
,update_by='{curUserId}'
,update_time=now()
where guid='{orderRefundGuid}' and supply_accept_way='0' and supply_accept='0'
;
