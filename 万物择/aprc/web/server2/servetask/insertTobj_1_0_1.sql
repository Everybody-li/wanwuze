-- ##Title 新增沟通任务目标用户表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 新增沟通任务目标用户表
-- ##CallType[ExSql]

-- ##input serveTaskGuid string[50] NOTNULL;品类名称guid，必填
-- ##input startDate string[10] NOTNULL;起始时间(前端默认选中最近一次终止时间，最近一次终止时间根据接口获取，最近一次终止时间及以前日期不可选)，必填
-- ##input endDate string[10] NOTNULL;终止时间(前端判断必须大于起始时间)，必填
-- ##input objectGuid string[36] NOTNULL;型号guid，必填
-- ##input objectOrgGuid string[36] NOTNULL;收取对象(前端固定传demand)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_serve2_serve_task_tobject(guid,serve_task_guid,object_guid,object_org_guid,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{serveTaskGuid}' as serve_task_guid
,'{objectGuid}' as object_guid
,'{objectOrgGuid}' as object_org_guid
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