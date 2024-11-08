-- ##Title web-服务应用信息-添加信息名称(企业信息)

-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-服务应用信息-添加信息名称(企业信息)

-- ##CallType[ExSql]

-- ##input profileTemplateGuid char[36] NOTNULL;档案模板guid，必填
-- ##input objectGuid char[36] NOTNULL;服务对象guid，必填
-- ##input objectOrgGuid string[36] NOTNULL;服务对象guid，必填
-- ##input fixedDatacode string[6] NOTNULL;档案模板guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @flag1=(select case when exists(select 1 from coz_target_object_profile where third_dynamic_gcode='{fixedDatacode}' and profile_template_guid='{profileTemplateGuid}' and object_org_guid='{objectOrgGuid}' and del_flag='0') then '0' else '1' end)
;
insert into coz_target_object_profile(guid,object_guid,object_org_guid,profile_template_guid,type,third_dynamic_gcode,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{objectGuid}' as objectGuid
,'{objectOrgGuid}' as objectOrgGuid
,'{profileTemplateGuid}' as profileTemplateGuid
,'2' as type
,'{fixedDatacode}' as fixedDatacode
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1'
limit 1
;
select 
case when(@flag1='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '信息名称不可重复添加！' else '操作成功' end as msg