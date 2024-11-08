-- ##Title web-服务应用信息-删除信息名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-服务应用信息-删除信息名称
-- ##CallType[ExSql]

-- ##input profileGuid char[36] NOTNULL;退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_target_object_profile
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{profileGuid}'
