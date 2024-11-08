-- ##Title app-创建招聘信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-创建招聘信息
-- ##CallType[ExSql]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid，必填
-- ##input categoryGuid char[36] NOTNULL;品类guid(app：岗位名称选中的值的guid)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input recruitGuid string[36] NOTNULL;招聘信息guid，必填

insert into coz_chat_recruit(guid,user_id,sd_path_guid,category_guid,del_flag,create_by,create_time,update_by,update_time)
select
'{recruitGuid}' as guid
,'{curUserId}' as user_id
,'{sdPathGuid}' as sd_path_guid
,'{categoryGuid}' as category_guid
,0 as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now()as update_time