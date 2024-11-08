-- ##Title app-查询订单交易规则内容
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询订单交易规则内容
-- ##CallType[QueryData]

-- ##input ruleGuid char[36] NULL;规则guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output ruleGuid char[36] 规则guid;规则guid
-- ##output content string[24] 规则内容;规则内容

select
guid as ruleGuid
,
replace(replace(content,'\n','\r\n'),'<br/>','') as content
from coz_order_bussiness_rule
where
guid='{ruleGuid}'