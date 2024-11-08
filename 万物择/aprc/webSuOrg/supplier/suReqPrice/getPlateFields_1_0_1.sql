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
,t.plate_field_value_remark as bizGuid
,t.operation
,CONCAT('{ChildRows_aprc\\webSuOrg\\supplier\\suReqPrice\\getPlateFieldValues_1_0_1:fieldGuid=''',t.plate_field_formal_guid,'''}') as `values`
from
coz_demand_request_price_plate t
where
t.request_price_guid='{requestPriceGuid}' and t.del_flag='0'
group by t.plate_field_norder,t.plate_field_formal_alias,t.plate_formal_guid,t.plate_field_formal_guid,t.operation,t.plate_field_value_remark