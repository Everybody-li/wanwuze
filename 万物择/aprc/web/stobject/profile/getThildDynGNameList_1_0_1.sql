-- ##Title web-服务应用信息-查询已添加的信息名称列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-服务应用信息-查询已添加的信息名称列表
-- ##CallType[QueryData]

-- ##input profileTemplateGuid char[36] NOTNULL;档案模板guid，必填
-- ##input objectGuid char[36] NOTNULL;服务对象guid，必填
-- ##input objectOrgGuid string[36] NOTNULL;机构类型guid
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t1.guid as profileGuid
,t1.object_guid as objectGuid
,t2.name as thildDynGName
,t1.object_org_guid as objectOrgGuid
from 
coz_target_object_profile t1
inner join
coz_model_fixed_data t2
on t1.third_dynamic_gcode=t2.code
where t1.object_guid='{objectGuid}' and t1.profile_template_guid='{profileTemplateGuid}' and t1.del_flag='0' and t2.del_flag='0' and t1.object_org_guid='{objectOrgGuid}'
order by t1.id