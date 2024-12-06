-- ##Title web-意向服务预约(对象联系阶段)-草稿提交
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-意向服务预约(对象联系阶段)-草稿提交
-- ##CallType[ExSql]

-- ##input serveTaskGuid string[36] NOTNULL;品类名称guid，必填
-- ##input serveTaskTobjectGuid string[36] NOTNULL;品类名称guid，必填
-- ##input serveTaskTobjectResultGuid string[36] NOTNULL;品类名称guid，必填
-- ##input sdPathGuid string[36] NOTNULL;型号guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_serve2_serve_task_tobject_result(guid,serve_task_guid,serve_task_tobject_guid,progress,result,result_remark,has_sdp,has_sdp_time,del_flag,create_by,create_time,update_by,update_time)
select
'{serveTaskTobjectResultGuid}' as guid
,'{serveTaskGuid}' as serve_task_guid
,'{serveTaskTobjectGuid}' as serve_task_tobject_guid
,'1' as progress
,'1' as result
,'直接预约服务名称系统自动同意服务' as result_remark
,'0' as has_sdp
,now() as has_sdp_time
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion
where not exists(select 1 from coz_serve2_serve_task_tobject_sdp where serve_task_tobject_guid='{serveTaskTobjectGuid}' and sd_path_guid='{sdPathGuid}') and not exists(select 1 from coz_serve2_serve_task_tobject_result where guid='{serveTaskTobjectResultGuid}')
limit 1
;
insert into coz_serve2_serve_task_tobject_sdp(guid,serve_task_guid,serve_task_tobject_guid,stobject_result_guid,sd_path_guid,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{serveTaskGuid}' as serve_task_guid
,'{serveTaskTobjectGuid}' as serve_task_tobject_guid
,'{serveTaskTobjectResultGuid}' as stobject_result_guid
,'{sdPathGuid}' as sd_path_guid
,'2' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion
where not exists(select 1 from coz_serve2_serve_task_tobject_sdp where serve_task_tobject_guid='{serveTaskTobjectGuid}' and sd_path_guid='{sdPathGuid}')
limit 1
;
