-- ##Title 更新支付订单状态为已完成
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 更新支付订单状态为已完成
-- ##CallType[ExSql]

-- ##input orderGuid char[36] NOTNULL;订单guid，内部订单号，必填
-- ##input channelPayOrderNo string[50] NOTNULL;渠道支付订单号，必填


update pay_order_payment
set pay_status='3'
,channel_pay_order_no='{channelPayOrderNo}'
,update_by='1'
,update_time=now()
where order_code='{orderGuid}'
