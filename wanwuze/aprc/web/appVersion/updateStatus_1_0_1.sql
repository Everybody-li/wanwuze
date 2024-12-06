-- ##Title 发布版本
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 发布版本
-- ##CallType[ExSql]

-- ##input versionGuid char[36] NOTNULL;版本guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_app_version
set 
status='1'
,publish_time=now()
,update_by='{curUserId}'
,update_time=now()
where guid='{versionGuid}'