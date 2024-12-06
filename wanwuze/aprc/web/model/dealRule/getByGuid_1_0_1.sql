-- ##Title web-查询节点交易规则管理列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describeweb-查询节点交易规则管理列表
-- ##CallType[QueryData]

-- ##input dealRuleGuid char[36] NULL;交易规则guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
t.guid as dealRuleGuid
,t.price_mode as priceMode
,t.serve_fee_flag as serveFeeFlag
,case when (t.category_guid='528a9e65-9d66-4e2d-a078-84a52096bb4b') then '0' else '1' end as canUpdFlag
from
coz_category_deal_rule t
where 
t.guid='{dealRuleGuid}'
