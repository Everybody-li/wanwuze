-- ##Title web-服务应用信息-材料/表单管理-删除材料/字段名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-服务应用信息-材料/表单管理-删除材料/字段名称
-- ##CallType[ExSql]

-- ##input profileFieldGuid char[36] NOTNULL;退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_target_object_profile_filed
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{profileFieldGuid}'
