-- ##Title app-采购-查询未付钱时需求供方报价信息内容
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-查询未付钱时需求供方报价信息内容
-- ##CallType[QueryData]

-- ##input requestPriceGuid string[500] NOTNULL;需求供方报价guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t.request_supply_guid as requestSupplyGuid
,t.guid as requestPriceGuid
,t.supply_company_name as supplyCompanyName
,model_name as modelName
,de_read_flag as deReadFlag
,CONCAT('{ChildRows_aprc\\app\\demand\\dReq\\pricePlates\\getUnPayPlates_1_0_1:requestPriceGuid=''',t.guid,'''}') as `plate`
from
coz_demand_request_price t
where
t.guid='{requestPriceGuid}' and t.del_flag='0'