-- ##Title app-采购-更新需求内容失效阅读标志为已读
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-更新需求内容失效阅读标志为已读
-- ##CallType[ExSql]

-- ##input requestGuid char[36] NOTNULL;需求guid，必填
-- ##input curUserId string[36] NOTNULL;需方用户id，必填

update coz_demand_request
set status0_read_flag='2'
,update_by='{curUserId}'
,update_time=now()
where (guid='{requestGuid}' or parent_guid='{requestGuid}') and (status0_read_flag='1')
;