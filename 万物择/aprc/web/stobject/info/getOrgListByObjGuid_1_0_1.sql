-- ##Title web-沟通应用信息-查看用户类型信息列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-沟通应用信息-查看用户类型信息列表
-- ##CallType[QueryData]

-- ##input objectGuid string[50] NOTNULL;用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t1.object_guid as objectGuid
,t1.guid as objectOrgGuid
,t1.org_name as orgName
,t1.org_type as orgType
,t1.r_type as roleType
,t1.register_city as registerCity
from
coz_target_object_org t1
where t1.object_guid='{objectGuid}' and t1.del_flag='0'
order by t1.id desc
