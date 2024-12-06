-- ##Title web-沟通任务派发
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 新增沟通任务主表
-- ##CallType[ExSql]

-- ##input serveTaskGuid string[36] NOTNULL;品类名称guid，必填
-- ##input startDate string[10] NOTNULL;起始时间(前端默认选中最近一次终止时间，最近一次终止时间根据接口获取，最近一次终止时间及以前日期不可选)，必填
-- ##input endDate string[10] NOTNULL;终止时间(前端判断必须大于起始时间)，必填
-- ##input sdPathGuid string[36] NOTNULL;型号guid，必填
-- ##input pfelangGuid string[36] NOTNULL;收取对象(前端固定传demand)，必填
-- ##input bizdict2Guid string[36] NOTNULL;型号guid，必填
-- ##input bizdict4Guid string[36] NOTNULL;型号guid，必填
-- ##input bizdict5Guid string[36] NOTNULL;型号guid，必填
-- ##input targetUserId string[36] NOTNULL;收取对象(前端固定传demand)，必填
-- ##input targetObjectNum int[>=0] NOTNULL;收取对象(前端固定传demand)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_serve2_serve_task(guid,user_id,start_date,end_date,sd_path_guid,pfelang_guid,bizdict2_guid,bizdict4_guid,bizdict5_guid,target_object_num,del_flag,create_by,create_time,update_by,update_time)
select
'{serveTaskGuid}' as guid
,'{targetUserId}' as user_id
,'{startDate}' as start_date
,'{endDate}' as end_date
,'{sdPathGuid}' as sd_path_guid
,'{pfelangGuid}' as pfelang_guid
,'{bizdict2Guid}' as bizdict2_guid
,'{bizdict4Guid}' as bizdict4_guid
,'{bizdict5Guid}' as bizdict5_guid
,'{targetObjectNum}' as target_object_num
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion
where
('{startDate}'<='{endDate}') and 
('{startDate}'>=left(now(),10)) 
limit 1
;