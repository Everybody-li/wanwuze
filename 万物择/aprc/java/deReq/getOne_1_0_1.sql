-- ##Title 需求-查询一个需求
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 需求-查询一个需求
-- ##CallType[QueryData]

-- ##input guid char[36] NOTNULL;需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t.guid
,t.user_id as userId
,t.parent_guid as parentGuid
,t.parent_request_price_guid as parentRequestPriceGuid
,t.supply_assign_rule_type as supplyAssignRuleType
,t.sd_path_guid as sdPathGuid
,t.sd_path_all_name as sdPathAllName
,t.cattype_guid as cattypeGuid
,t.cattype_name as cattypeName
,t.category_guid as categoryGuid
,t.category_name as categoryName
,t.price_mode as priceMode
,t.serve_fee_flag as serveFeeFlag
,t.need_deliver_flag as needDeliverFlag
,t.done_flag as doneFlag
,t.status0_read_flag as status0ReadFlag
,t.status0_read_time as status0ReadTime
from
coz_demand_request t
where 
t.guid='{guid}' 
