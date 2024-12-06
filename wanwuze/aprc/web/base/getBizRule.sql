-- ##Title web-查询交易规则列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询交易规则列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output guid char[36] 规则id;规则id
-- ##output name string[50] 规则名称;规则名称

select
t.guid
,t.name
from
coz_order_bussiness_rule t
where
del_flag='0'
