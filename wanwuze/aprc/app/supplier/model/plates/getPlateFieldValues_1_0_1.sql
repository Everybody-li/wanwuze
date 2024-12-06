-- ##Title web-查询字段值配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询字段值配置列表
-- ##CallType[QueryData]


select
if(t.plate_field_code in ('f00051','f00062')  ,cast(t.plate_field_value/100 as decimal(18,2)),t.plate_field_value) as value
,t.guid as quaUserPlatelGuid
,t.plate_field_formal_guid as fieldGuid
from
coz_category_supplier_model_plate t
where
t.model_guid='{modelGuid}' and t.del_flag='0'