-- ##Title web-供应-查询线上缴纳违约费用支付状态
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-供应-查询线上缴纳违约费用支付状态
-- ##CallType[QueryData]

-- ##input judgeFeeGuid char[36] NULL;违约费用guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output payStatus string[1] 支付状态;支付状态



select 
case when (t1.pay_status='2' or t1.pay_status='3') then '1' else '0' end  as payStatus
from 
coz_order_judge_fee t1
where 
t1.guid='{judgeFeeGuid}'

