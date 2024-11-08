-- ##Title 查询未失效的需求内容数据
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 查询未失效的需求内容数据
-- ##CallType[QueryData]

select
t.request_guid as requestGuid
,t.plate_formal_guid as plateGuid
,t.plate_formal_alias as plateAlias
,t.plate_code as plateFDCode
,t.plate_norder as plateNorder
,t.plate_field_formal_guid as plateFieldGuid
,t.plate_field_code as plateFieldFDCode
,t.plate_field_formal_alias as plateFieldAlias
,t.plate_field_norder as plateFieldNorder
,t.operation
,t.plate_field_content_gc as fieldContentGc
,t.plate_field_value as plateFieldValue
from
coz_demand_request_plate t
left join
coz_demand_request t1
on t.request_guid=t1.guid
where
t1.category_guid='{categoryGuid}' and t.del_flag='0' and t1.done_flag='0' and t1.del_flag='0' and t1.cancel_flag='0'