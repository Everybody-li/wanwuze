-- ##Title app-供应-删除需方需求(实际为删除消息通知)
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-删除需方需求(实际为删除消息通知)
-- ##CallType[ExSql]

-- ##input matchNoticeGuid char[36] NOTNULL;供需匹配消息通知gui，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_demand_request_match_notice
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{matchNoticeGuid}'
;


