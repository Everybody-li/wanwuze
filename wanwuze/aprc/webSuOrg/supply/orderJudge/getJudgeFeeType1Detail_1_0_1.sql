-- ##Title app-采购/供应-订单违约费用缴纳详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购/供应-订单违约费用缴纳详情
-- ##CallType[QueryData]

-- ##input judgeFeeGuid char[36] NULL;违约费用guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output categoryGuid char[36] 品类guid;品类guid
-- ##output categoryImg string[50] 品类图片;品类图片
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output categoryAlias string[50] 品类别名;品类别名，多个逗号隔开
-- ##output orderNo string[24] 采购编号;采购编号
-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output orderTime string[10] 0000-00-00;订单创建时间（格式：0000-00-00）
-- ##output judgeFee decimal[>=0] 1;违约金额
-- ##output judgeGuid char[36] 仲裁guid;仲裁guid
-- ##output judgeFeeGuid char[36] 违约费用guid;违约费用guid
-- ##output judgeFeePayType string[1] 1;违约费用缴纳标志（0：未缴纳，其他值：已缴纳）
-- ##output judgeFeePayProve string[600] 违约费用缴纳证明图片;违约费用缴纳证明图片，多个逗号隔开
-- ##output judgeFeePayTime string[10] 0000-00-00;违约费用缴纳时间（格式：0000-00-00）
-- ##output bizRuleGuid char[36] 适用规则guid;适用规则guid
-- ##output bizRuleName string[50] 适用规则名称;适用规则名称
-- ##output confirmPayFlag string[1] 1;缴纳费用确认(1：未结算，2：已结算)


select 
t4.guid as categoryGuid
,t4.img as categoryImg
,t4.name as categoryName
,t4.alias as categoryAlias
,t3.order_no as orderNo
,t.order_guid as orderGuid
,left(t3.create_time,10) as orderTime
,cast(t.disobey_fee/100 as decimal(18,2)) as judgeFee
,t.guid as judgeGuid
,t1.guid as judgeFeeGuid
,t1.pay_status as judgeFeePayType
,case when(t1.pay_prove='') then '0' else '1' end as judgeFeeProveType
,t1.pay_prove as judgeFeePayProve
,left(t1.pay_time,10) as judgeFeePayTime
,t1.biz_rule_guid as bizRuleGuid
,t1.biz_rule_name as bizRuleName
,t1.confirm_pay_flag as confirmPayFlag
from 
coz_order_judge_fee t1
left join 
coz_order_judge t
on t1.judge_guid=t.guid 
left join 
coz_order t3 
on t.order_guid=t3.guid 
left join 
coz_category_info t4
on t3.category_guid=t4.guid 
where 
t1.guid='{judgeFeeGuid}'

