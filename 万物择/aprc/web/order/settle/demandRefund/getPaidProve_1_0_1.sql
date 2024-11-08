-- ##Title web-查看付款证明
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看付款证明
-- ##CallType[QueryData]

-- ##input refundGuid char[36] NOTNULL;退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output refundGuid char[36] 退货guid;退货guid
-- ##output confirmRefundPayTime string[10] 0000-00-00;提交（结算）日期（格式：0000-00-00）
-- ##output confirmRefundPayProve string[600] 付款证明图片;付款证明图片，多个逗号隔开
-- ##output confirmRefundPayRemark string[50] 付款说明;付款说明

select
t.guid as refundGuid
,left(t.confirm_refund_pay_time,10) as confirmRefundPayTime
,t.confirm_refund_pay_prove as confirmRefundPayProve
,t.confirm_refund_pay_remark as confirmRefundPayRemark
from
coz_order_refund t
where 
t.guid='{refundGuid}' and t.del_flag='0'