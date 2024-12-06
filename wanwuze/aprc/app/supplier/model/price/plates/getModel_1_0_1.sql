-- ##Title app-供应-型号-查询型号价格内容
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-型号-查询型号价格内容
-- ##CallType[QueryData]

-- ##input modelPriceGuid string[500] NOTNULL;供方品类型号Guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t.model_guid as modelGuid
,t.guid as modelPriceGuid
,t.bank_user_name as bankUserName
,t.bank_name as bankName
,t.bank_user_no as bankUserNo
,t.bank_addr as bankAddr
,t.supply_company_name as supplyCompanyName
,CONCAT('{ChildRows_aprc\\app\\supplier\\model\\price\\plates\\getPlates_1_0_1:modelPriceGuid=''',t.guid,'''}') as `plate`
from
coz_category_supplier_model_price t
where
t.guid='{modelPriceGuid}' and t.del_flag='0'