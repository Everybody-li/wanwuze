-- ##Title app-供应-提交退货收货地址
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-提交退货收货地址
-- ##CallType[ExSql]

-- ##input orderRefundGuid char[36] NOTNULL;订单退货guid，必填
-- ##input receiverName string[50] NOTNULL;收货姓名，必填
-- ##input receiverPhone string[50] NOTNULL;收货手机号，必填
-- ##input addr string[50] NOTNULL;地址详情，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

INSERT INTO coz_order_refund_supply_addr
(guid,order_refund_guid,receiver_name,receiver_phone,nation_name,province_name,city_name,district_name,addr,del_flag,create_by,create_time,update_by,update_time) 
select 
uuid() as guid
,'{orderRefundGuid}' as code
,'{receiverName}' as name
,'{receiverPhone}' as bothSD_flag
,'' as alias
,'' as img
,'' as mode
,'' as cattypeguid
,'{addr}' as cattypename
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_order_refund
where 
guid='{orderRefundGuid}' and supply_accept_way=0 and supply_accept=0 and not exists(select 1 from coz_order_refund_supply_addr where order_refund_guid='{orderRefundGuid}')
;