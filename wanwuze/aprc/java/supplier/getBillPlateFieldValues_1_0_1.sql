-- ##Title web-查询字段名称配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询字段名称配置列表
-- ##CallType[QueryData]


select
t.plate_field_value as fieldValue
,t.plate_field_formal_guid as fieldGuid
,t.supplier_guid as supplierGuid
from
coz_category_supplier_bill  t
where
t.supplier_guid in ({supplierGuid}) and t.plate_code in ({plateFDCode}) and t.del_flag='0' and t.status='1'