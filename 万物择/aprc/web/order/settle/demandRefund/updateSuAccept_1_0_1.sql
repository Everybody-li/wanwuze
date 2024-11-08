-- ##Title web-系统验收通过
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-系统验收通过
-- ##CallType[ExSql]

-- ##input refundGuid char[36] NOTNULL;退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_order_refund
set refund_pay_flag=1
,refund_pay_time=now()
,update_by='0'
,supply_accept_way='2'
,supply_accept='1'
,supply_accept_time=now()
,confirm_refund_pay_prove=''
,confirm_refund_pay_time=now()
,confirm_refund_pay_remark=''
,confirm_refund_pay_flag='1'
,update_by='{curUserId}'
,update_time=now()
where guid='{refundGuid}'
