-- ##Title web-查询板块配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询板块配置列表
-- ##CallType[QueryData]


select
t.status
,'2' as bizType
,t.plate_norder as norder
,t.plate_formal_alias as alias
,t.plate_formal_guid as plateGuid
,t.model_price_guid as modelPriceGuid
,t.plate_code as plateFDCode
,CONCAT('{ChildRows_aprc\\webSuOrg\\supplier\\model\\price\\plates\\getPlateFields_1_0_1:plateGuid=''',t.plate_formal_guid,'''}') as `field`
from
coz_category_supplier_model_price_plate t
where
t.model_price_guid='{modelPriceGuid}' and t.del_flag='0'
group by t.status,t.plate_norder,t.plate_formal_alias,t.plate_formal_guid,t.model_price_guid,t.plate_code