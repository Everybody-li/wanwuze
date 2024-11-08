-- ##Title web-根据规则id查询交易规则详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-根据规则id查询交易规则详情
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input Guid string[50] NOTNULL;规则id，必填

-- ##output Guid char[36] 规则id;规则id
-- ##output name string[50] 规则名称;规则名称
-- ##output content string[50] 规则内容;规则内容

select
t.Guid
,t.name
,t.content
from
coz_order_bussiness_rule t
where 
guid='{Guid}'
