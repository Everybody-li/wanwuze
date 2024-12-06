-- ##Title web-更新需求删除提示标志为已读
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-更新需求删除提示标志为已读
-- ##CallType[ExSql]

-- ##input demandRequestGuid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_demand_request
set cancel_xjsuser_read_flag='2'
,cancel_xjsuser_read_time=now()
,update_by='{curUserId}'
,update_time=now()
where guid='{demandRequestGuid}' and cancel_xjsuser_read_flag='1'
;