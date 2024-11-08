-- ##Title web-查询字段名称配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询字段名称配置列表
-- ##CallType[QueryData]


select
t.plate_field_value as fieldValue
,t.plate_field_formal_guid as fieldGuid
,t.model_guid
from
coz_category_supplier_model_plate t
left join
coz_category_supplier_model t1
on t.model_guid=t1.guid
where
t1.supplier_guid in ({supplierGuid}) and t.plate_code in ({plateFDCode}) and t.del_flag='0' and t.status='1'