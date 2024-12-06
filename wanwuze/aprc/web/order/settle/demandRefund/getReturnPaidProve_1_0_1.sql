-- ##Title web-查看原路退款付款证明
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看原路退款付款证明
-- ##CallType[QueryData]

-- ##input refundGuid char[36] NOTNULL;退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output buyerAccount string[20] 原路退还支付说明;原路退还支付说明(取退还时间+支付类型+退款金额+支付账号)20220214支付宝原路退款xxx.xx元到159****1234

select 
concat(left(t.refund_pay_time+0,8),if(t1.pay_type='1','微信原路退款','支付宝原路退款'),t1.pay_fee,'元到',JSON_UNQUOTE(user_pay_extra -> '$.buyer_logon_id')) as returnPayMsg
from 
coz_order_refund t
left join
coz_order t1
on t.order_guid=t1.guid
where 
t.guid='{refundGuid}'