-- ##Title web-查询字段值配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询字段值配置列表
-- ##CallType[QueryData]


select
case when ((t.plate_field_code='f00014' or t.plate_field_code='f00012') and t1.done_flag='0') then '*' else (if(t.plate_field_code in ('f00051','f00062')  ,cast(t.plate_field_value/100 as decimal(18,2)),t.plate_field_value)) end as value
,t.guid as requestPlateGuid
,t.plate_field_formal_guid as fieldGuid
from
coz_demand_request_plate t
left join
coz_demand_request t1
on t.request_guid=t1.guid
where
t.request_guid='{requestGuid}' and t.del_flag='0'