-- ##Title web-查询指派规则
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询指派规则
-- ##CallType[QueryData]

-- ##input categoryGuid string[36] NOTNULL;指派规则guid，必填

-- ##input curUserId string[36] MOTNULL;登录用户id，必填

-- ##output ruleType int[>=0] 0;指派规则类型（0：未选中，1：同一单子，价格低者中单；同价格，已中单少者中单；已中单数量相同，早合作者中单；以上均满足，则随机。）

select
rule_type as ruleType
from
coz_category_model_supply_assign t
where 
t.category_guid ='{categoryGuid}'