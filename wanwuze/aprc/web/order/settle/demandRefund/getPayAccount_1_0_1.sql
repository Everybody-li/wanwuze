-- ##Title web-查看收款账号
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看收款账号
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output thirdPayType int[>=0] 1;支付类型（1：微信，2：支付宝）
-- ##output buyerAccount string[20] 买家支付登录账号;买家支付登录账号

select 
pay_type as thirdPayType
,JSON_UNQUOTE(user_pay_extra -> '$.buyer_logon_id') as buyerAccount 
from 
coz_order
where 
guid='{orderGuid}'