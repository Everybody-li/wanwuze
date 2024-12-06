-- ##Title app-采购-查询未付钱时需求供方报价信息内容
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-查询未付钱时需求供方报价信息内容
-- ##CallType[QueryData]

-- ##input requestPriceGuid string[36] NOTNULL;需求供方报价guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t.request_supply_guid as requestSupplyGuid
,t.guid as requestPriceGuid
,t.bank_user_name as bankUserName
,t.bank_user_no as bankUserNo
,t.bank_addr as bankAddr
,t.bank_name as bankName
,t.supply_company_name as supplyCompanyName
,model_name as modelName
,CONCAT('{ChildRows_aprc\\web\\order\\detail\\pricePlates\\getPlates_1_0_1:requestPriceGuid=''',t.guid,'''}') as `plate`
from
coz_demand_request_price t
where
t.guid='{requestPriceGuid}' and t.del_flag='0'