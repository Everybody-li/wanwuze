-- ##Title 修改服务任务的目标用户意向预约标志
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 修改服务任务的目标用户意向预约标志
-- ##CallType[ExSql]

-- ##input serveTaskTobjectResultGuid string[50] NOTNULL;品类名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_serve2_serve_task_tobject_sdp
set del_flag='0'
,update_by='{curUserId}'
,update_time=now()
where stobject_result_guid='{serveTaskTobjectResultGuid}'
;
update coz_serve2_serve_task_tobject_result
set has_sdp='1'
,has_sdp_time=now()
,update_by='{curUserId}'
,update_time=now()
where guid='{serveTaskTobjectResultGuid}' and has_sdp='0'
;