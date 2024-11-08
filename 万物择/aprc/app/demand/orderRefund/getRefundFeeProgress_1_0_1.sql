-- ##Title app-采购-查询退款详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-查询退款详情
-- ##CallType[QueryData]

-- ##input orderRefundGuid char[36] NULL;订单退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output orderRefundGuid char[36] 订单退款guid;订单退款guid
-- ##output refundFee decimal[>=0] 0;可退款金额（后端除以100并保留两位小数）
-- ##output confirmRefundPayFlag string[1] 1;退款支付标志(0：未支付，1：已支付)
-- ##output confirmRefundPayProve string[600] 退款支付证明图片;退款支付证明图片，多个逗号隔开
-- ##output confirmRefundPayTime string[50] 退款时间(格式：0000-00-00)
-- ##output payRemark string[1] 付款证明说明;付款证明说明(后端拼接内容：{退款到账时间} + {支付类型} + “退回“ + {退款金额})

select 
t1.order_guid as orderGuid
,t1.guid as orderRefundGuid
,CAST((t1.refund_fee/100) AS decimal(18,2)) as refundFee
,t1.confirm_refund_pay_flag as confirmRefundPayFlag
,t1.confirm_refund_pay_prove as confirmRefundPayProve
,left(t1.confirm_refund_pay_time,10) as confirmRefundPayTime
,concat(left(t1.confirm_refund_pay_time,10),case when(t3.pay_type='1') then '微信' else '支付宝' end,'退回',cast(t1.refund_fee/100 as decimal(18,2)),'元') as payRemark
from 
coz_order_refund t1
left join 
coz_order t3 
on t1.order_guid=t3.guid 
where 
t1.guid='{orderRefundGuid}'


