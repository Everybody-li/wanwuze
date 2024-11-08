-- ##Title 仲裁-查询仲裁费用详情_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 仲裁-查询仲裁费用详情_1_0_1
-- ##CallType[QueryData]

-- ##input judgeFeeGuid char[36] NULL;违约费用guid，必填

-- ##output judgeFeeGuid char[36] 仲裁费用guid;仲裁费用guid
-- ##output feeNo string[50] 费用编号;费用编号
-- ##output Fee decimal[>=0] 1;违约金额
-- ##output payNo string[20] 支付流水号;支付流水号
-- ##output payTime string[30] 支付时间;支付时间
-- ##output payStatus string[1] 支付状态;支付状态
-- ##output payType string[1] 支付类型;支付类型


select 
t1.guid as judgeFeeGuid
,t1.fee_no as feeNo
,t1.fee as Fee
,t1.pay_no as payNo
,left(t1.pay_time,19) as payTime
,t1.pay_status as payStatus
,t1.pay_type as payType
from 
coz_order_judge_fee t1
where 
t1.guid='{judgeFeeGuid}'

