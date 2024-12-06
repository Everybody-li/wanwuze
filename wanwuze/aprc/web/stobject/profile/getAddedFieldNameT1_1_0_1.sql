-- ##Title web-服务应用信息-查询已添加的信息名称列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-服务应用信息-查询已添加的信息名称列表
-- ##CallType[QueryData]

-- ##input profileGuid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t1.guid as fieldGuid
,t1.field_name as fieldName
,t1.field_value as fieldValue
from 
coz_target_object_profile_filed t1
where t1.profile_guid='{profileGuid}' and del_flag='0' and t1.field_type='1'
order by t1.id