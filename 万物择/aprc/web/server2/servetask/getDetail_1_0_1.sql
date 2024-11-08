-- ##Title web-查询服务任务派发详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务任务派发详情
-- ##CallType[QueryData]

-- ##input serveTaskGuid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t1.guid as serveTaskGuid
,t1.user_id as userId
,left(t1.start_date,10) as startDate
,left(t1.end_date,10) as endDate
,t2.name as sdPName
,t3.file_name as fileName
,t4.user_name as userName
,t4.nick_name as nickName
,concat('(+86)',t4.phonenumber) as phonenumber
,left(t1.create_time,10) as AssignDate
,t1.target_object_num as targetObjectNum
,t3.file_value as fileValue
,left(t3.create_time,16) as fileCreateTime
from 
coz_serve2_serve_task t1
inner join
coz_cattype_sd_path t2
on t1.sd_path_guid=t2.guid
inner join
coz_serve2_pfelang t3
on t1.pfelang_guid=t3.guid
inner join
sys_user t4
on t1.user_id=t4.user_id
where t1.guid='{serveTaskGuid}' and t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and t4.del_flag='0'
order by t1.id