-- ##Title web-服务应用信息-添加信息名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-服务应用信息-添加信息名称
-- ##CallType[ExSql]

-- ##input profileGuid char[36] NOTNULL;服务对象guid，必填
-- ##input fixedDatacode string[6] NOTNULL;档案模板guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @flag1=(select case when exists(select 1 from coz_target_object_profile_filed where field_code='{fixedDatacode}' and profile_guid='{profileGuid}' and del_flag='0') then '0' else '1' end)
;
insert into coz_target_object_profile_filed(guid,profile_guid,field_type,field_code,field_name,field_value,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{profileGuid}' as profile_guid
,'2' as field_type
,'{fixedDatacode}' as field_code
,'' as field_name
,'' as field_value
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
,case when(@flag1='0') then '字段名称不可重复添加！' else '操作成功' end as msg