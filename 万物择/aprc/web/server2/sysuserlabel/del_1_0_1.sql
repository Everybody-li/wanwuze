-- ##Title web-服务应用信息-删除信息名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-服务应用信息-删除信息名称
-- ##CallType[ExSql]

-- ##input userLabelGuid char[36] NOTNULL;退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_server2_sys_user_label
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{userLabelGuid}'
