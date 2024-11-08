-- ##Title web-提交付款证明
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-提交付款证明
-- ##CallType[ExSql]

-- ##input refundGuid char[36] NOTNULL;退货guid，必填
-- ##input confirmRefundPayProve string[600] NOTNULL;付款证明图片url（多个逗号隔开），必填
-- ##input confirmRefundPayRemark string[50] NOTNULL;付款备注，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_order_refund
set refund_pay_flag=1
,confirm_refund_pay_prove='{confirmRefundPayProve}'
,confirm_refund_pay_time=now()
,confirm_refund_pay_time='{confirmRefundPayRemark}'
,confirm_refund_pay_flag='1'
,update_by='{curUserId}'
,update_time=now()
where guid='{refundGuid}'
