-- ##Title web-服务应用信息-表单管理-编辑字段内容
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-服务应用信息-表单管理-编辑字段内容
-- ##CallType[ExSql]

-- ##input fieldGuid char[36] NOTNULL;退货guid，必填
-- ##input fieldValue string[100] NOTNULL;登录用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_target_object_profile_filed
set field_value='{fieldValue}'
,update_by='{curUserId}'
,update_time=now()
where guid='{fieldGuid}'
