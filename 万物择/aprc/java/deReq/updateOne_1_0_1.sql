-- ##Title 需求-更新一个需求
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 需求-更新一个需求
-- ##CallType[ExSql]

-- ##input guid char[36] NOTNULL;需求guid，必填
-- ##input parentGuid char[36] NOTNULL;父级需求guid，必填
-- ##input needDeliverFlag string[1] NOTNULL;需要物流标志，必填
-- ##input parentRequestPriceGuid string[36] NULL;物流需求组成部分包含父需求供方报价信息，非必填
-- ##input supplyAssignRuleType int[>=0] NOTNULL;子(物流)需求供方指派规则，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_demand_request
set parent_guid='{parentGuid}' 
,need_deliver_flag='{needDeliverFlag}' 
,parent_request_price_guid='{parentRequestPriceGuid}' 
,supply_assign_rule_type={supplyAssignRuleType}
,update_by='{curUserId}' 
,update_time=now()
where guid='{guid}' 

