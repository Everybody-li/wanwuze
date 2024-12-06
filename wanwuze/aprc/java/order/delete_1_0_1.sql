-- ##Title 订单支付失败/取消后的业务
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 订单支付失败/取消后的业务
-- ##CallType[ExSql]

-- ##input orderGuid string[200] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_order
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{orderGuid}' or parent_guid='{orderGuid}'


