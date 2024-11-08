-- ##Title web-保存进度标签
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-保存进度标签
-- ##CallType[ExSql]

-- ##input serveTaskGuid char[36] NOTNULL;退货guid，必填
-- ##input serveTaskTobjectGuid char[36] NOTNULL;退货guid，必填
-- ##input progress string[1] NOTNULL;登录用户id，必填
-- ##input result string[1] NOTNULL;登录用户id，必填
-- ##input resultRemark string[200] NULL;登录用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @flag1=(select case when exists(select 1 from coz_serve2_serve_task_tobject_result where serve_task_tobject_guid='{serveTaskTobjectGuid}' and del_flag='0' and progress='{progress}') then '0' else '1' end)
;
insert into coz_serve2_serve_task_tobject_result(guid,serve_task_guid,serve_task_tobject_guid,progress,result,result_remark,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{serveTaskGuid}' as serve_task_guid
,'{serveTaskTobjectGuid}' as serve_task_tobject_guid
,'{progress}' as progress
,'{result}' as result
,'{resultRemark}' as result_remark
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion
where
@flag1='1'
limit 1
;
select 
case when(@flag1='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '当前进度已经操作过，请进行查看！' else '操作成功' end as msg
;