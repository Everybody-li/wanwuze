-- ##Title 需求-查询一个需求全部内容
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 需求-查询一个需求全部内容
-- ##CallType[QueryData]

-- ##input requestGuid char[36] NOTNULL;需求guid，必填


select
t2.user_id as userId
,t2.category_guid as categoryGuid
,t2.category_name as categoryName
,t1.plate_formal_guid as plateGuid
,t1.plate_norder as plateNorder
,t1.plate_code as plateFDCode
,t1.plate_formal_alias as plateAlias
,t1.plate_field_formal_guid as plateFieldGuid
,t1.plate_field_formal_alias as plateFieldAlias
,t1.plate_field_norder as plateFieldNorder
,t1.operation
,t1.plate_field_code as plateFieldFDCode
,t1.plate_field_value as plateFieldValue
from
coz_demand_request_plate t1
left join
coz_demand_request t2
on t1.request_guid=t2.guid
where
t1.request_guid='{requestGuid}' and t1.del_flag='0' and t1.`status`='1' 