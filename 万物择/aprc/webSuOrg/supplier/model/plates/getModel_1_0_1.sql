-- ##Title app-供应-型号-查询供方需求范围内容
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-型号-查询供方需求范围内容
-- ##CallType[QueryData]

-- ##input modelGuid string[36] NOTNULL;供方品类型号Guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t.guid as modelGuid
,t.name as modelName
,CONCAT('{ChildRows_aprc\\webSuOrg\\supplier\\model\\plates\\getPlates_1_0_1:modelGuid=''',t.guid,'''}') as `plate`
from
coz_category_supplier_model t
where
t.guid='{modelGuid}' and t.del_flag='0'