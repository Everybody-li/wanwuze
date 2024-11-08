-- ##Title web-查询字段名称配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询字段名称配置列表
-- ##CallType[QueryData]

select
norder
,case when ((t.plate_field_code='f00014' or t.plate_field_code='f00012') and t.done_flag='0') then '*' else t.alias end as alias
,plateGuid
,fieldGuid
,operation
,`values`
from
(
select
t.plate_field_norder as norder
,t.plate_field_formal_alias as alias
,t.plate_formal_guid as plateGuid
,t.plate_field_formal_guid as fieldGuid
,t.operation
,t.plate_field_code
,t1.done_flag
,CONCAT('{ChildRows_aprc\\web\\order\\detail\\dReqPlates\\getPlateFieldValues_1_0_1:fieldGuid=''',t.plate_field_formal_guid,'''}') as `values`
from
coz_demand_request_plate t
left join
coz_demand_request t1
on t.request_guid=t1.guid
where
t.request_guid='{requestGuid}' and t.del_flag='0'
group by t.plate_field_norder,t.plate_field_formal_alias,t.plate_formal_guid,t.plate_field_formal_guid,t.operation,t1.done_flag,t.plate_field_code
)t
