-- ##Title web-意向服务预约(材料收集阶段和信息应用阶段)
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-意向服务预约(材料收集阶段和信息应用阶段)
-- ##CallType[ExSql]

-- ##input serveTaskGuid string[36] NOTNULL;品类名称guid，必填
-- ##input serveTaskTobjectGuid string[36] NOTNULL;品类名称guid，必填
-- ##input serveTaskTobjectResultGuid string[36] NOTNULL;品类名称guid，必填
-- ##input sdPathGuid string[36] NOTNULL;型号guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_serve2_serve_task_tobject_sdp(guid,serve_task_guid,stobject_result_guid,sd_path_guid,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{serveTaskGuid}' as serve_task_guid
,'{serveTaskTobjectResultGuid}' as stobject_result_guid
,'{sdPathGuid}' as sd_path_guid
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion
limit 1

;