-- ##Title web-查询字段名称配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询字段名称配置列表
-- ##CallType[QueryData]

select
t.plate_field_norder as norder
,t.plate_field_formal_alias as alias
,t.plate_formal_guid as plateGuid
,t.plate_field_formal_guid as fieldGuid
,t.plate_field_code as fieldFDCode
,t.plate_field_content_gc as contentFDCode
,t.operation
,CONCAT('{ChildRows_aprc\\app\\supplier\\model\\plates\\getPlateFieldValues_1_0_1:fieldGuid=''',t.plate_field_formal_guid,'''}') as `values`
from
coz_category_supplier_model_plate t
where
t.model_guid='{modelGuid}' and t.del_flag='0'
group by t.plate_field_norder,t.plate_field_formal_alias,t.plate_formal_guid,t.plate_field_formal_guid,t.operation,t.plate_field_code,t.plate_field_content_gc