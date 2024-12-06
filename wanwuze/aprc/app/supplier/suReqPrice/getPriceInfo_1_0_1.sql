-- ##Title app-采购-查询未付钱时需求供方报价信息内容
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-查询未付钱时需求供方报价信息内容
-- ##CallType[QueryData]

-- ##input requestPriceGuid string[500] NOTNULL;需求供方报价guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t.user_id as userId
,t.model_guid as modelGuid
,t.model_name as modelName
,t.bank_user_name as bankUserName
,t.bank_name as bankName
,t.bank_user_no as bankUserNo
,t.bank_addr as bankAddr
,t.supply_company_name as supplyCompanyName
,CONCAT('{ChildRows_aprc\\app\\supplier\\suReqPrice\\getPlates_1_0_1:requestPriceGuid=''',t.guid,'''}') as `plate`
from
coz_demand_request_price t
where
t.guid='{requestPriceGuid}' and t.del_flag='0'
