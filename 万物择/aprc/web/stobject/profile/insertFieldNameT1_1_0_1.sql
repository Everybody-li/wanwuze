-- ##Title web-服务应用信息-材料管理-添加材料
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-服务应用信息-材料管理-添加材料
-- ##CallType[ExSql]

-- ##input fieldName string[30] NOTNULL;档案模板guid，必填
-- ##input profileGuid char[36] NOTNULL;档案模板guid，必填
-- ##input fieldValue string[100] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


insert into coz_target_object_profile_filed(guid,profile_guid,field_type,field_code,field_name,field_value,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{profileGuid}' as profile_guid
,'1' as field_type
,'image0' as field_code
,'{fieldName}' as field_name
,'{fieldValue}' as field_value
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
