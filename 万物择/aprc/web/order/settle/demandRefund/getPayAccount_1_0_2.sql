-- ##Title web-查看收款账号
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看收款账号
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
case when(t2.refund_pay_status<>'2') then '未退款' else t1.pay_type end as thirdPayType
,case when(t2.refund_pay_status<>'2') then '未退款' when(t1.pay_type='1') then '微信' when(t1.pay_type='2') then '支付宝' else '' end as thirdPayTypeStr
,case when(t2.refund_pay_status<>'2') then '未退款' else JSON_UNQUOTE(t1.user_pay_extra -> '$.buyer_logon_id') end as buyerAccount
,cast(t2.refund_fee/100 as decimal(18,2)) as payFee
,case when(t2.refund_pay_status<>'2') then '未退款' else t2.create_time end as refundApplyTime
,case when(t2.refund_pay_status<>'2') then '未退款' else t2.refund_pay_time end as refundToAccTime
from 
coz_order t1
inner join
coz_order_cancel t2
on t1.guid=t2.order_guid
where 
t1.guid='{orderGuid}' and t1.del_flag='0' and t2.del_flag='0'
union all
select 
case when(t3.confirm_refund_pay_flag='0') then '未退款' else t1.pay_type end as thirdPayType
,case when(t3.confirm_refund_pay_flag='0') then '未退款' when(t1.pay_type='1') then '微信' when(t1.pay_type='2') then '支付宝' else '' end as thirdPayTypeStr
,case when(t3.confirm_refund_pay_flag='0') then '未退款' else JSON_UNQUOTE(t1.user_pay_extra -> '$.buyer_logon_id') end as buyerAccount
,cast(t3.refund_fee/100 as decimal(18,2)) as payFee
,case when(t3.confirm_refund_pay_flag='0') then '未退款' else t3.create_time end as refundApplyTime
,case when(t3.confirm_refund_pay_flag='0') then '未退款' else t3.refund_pay_time end as refundToAccTime
from 
coz_order t1
inner join
coz_order_refund t3
on t1.guid=t3.order_guid
where 
t1.guid='{orderGuid}' and t1.del_flag='0' and t3.del_flag='0'