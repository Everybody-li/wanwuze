-- ##Title web-查询字段值配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询字段值配置列表
-- ##CallType[QueryData]


select
case when (t.plate_field_content_gc='c00008' or t.plate_field_content_gc='c00009' or t.plate_field_content_gc='c00010' or t.plate_field_content_gc='c00011' or t.plate_field_content_gc='c00012' or t.plate_field_content_gc='c00021' or t.plate_field_content_gc='c00022' or t.plate_field_content_gc='c00023') then (select path_name from sys_city_code where code=t.plate_field_value limit 1) else if(t.plate_field_code in ('f00051','f00062')  ,concat(cast(t.plate_field_value/100 as decimal(18,2)),ifnull(t.plate_field_value_remark,'')),t.plate_field_value) end as value
,t.plate_field_value as bizCode
,t.guid as reqPricePlateGuid
,t.plate_field_formal_guid as fieldGuid
from
coz_demand_request_price_plate t
where
t.request_price_guid='{requestPriceGuid}' and t.del_flag='0'