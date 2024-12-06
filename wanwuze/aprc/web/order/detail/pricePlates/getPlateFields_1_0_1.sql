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
,case when(plate_field_code='f00013' or plate_field_code='f00015') then '*' else t.plate_field_code end as code
,t.operation
,CONCAT('{ChildRows_aprc\\web\\order\\detail\\pricePlates\\getPlateFieldValues_1_0_1:fieldGuid=''',t.plate_field_formal_guid,'''}') as `values`
from
coz_demand_request_price_plate t
where
t.request_price_guid='{requestPriceGuid}' and t.del_flag='0'
group by t.plate_field_norder,t.plate_field_formal_alias,t.plate_formal_guid,t.plate_field_formal_guid,t.plate_field_code,t.operation