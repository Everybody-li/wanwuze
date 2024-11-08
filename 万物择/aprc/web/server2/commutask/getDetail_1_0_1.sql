-- ##Title web-服务应用信息-查询已添加的信息名称列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-服务应用信息-查询已添加的信息名称列表
-- ##CallType[QueryData]

-- ##input commuTaskGuid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t1.guid as commuTaskGuid
,t1.user_id as userId
,left(t1.start_date,10) as startDate
,left(t1.end_date,10) as endDate
,t2.name as sdPName
,t3.file_name as fileName
,t4.user_name as userName
,t4.nick_name as nickName
,concat('(+86)',t4.phonenumber) as phonenumber
,t1.create_time as AssignDate
,t1.target_object_num as targetObjectNum
,concat(left(t1.start_date,10),'---',left(t1.end_date,10)) as taskTime
from 
coz_serve2_commu_task t1
inner join
coz_cattype_sd_path t2
on t1.sd_path_guid=t2.guid
inner join
coz_serve2_pfelang t3
on t1.pfelang_guid=t3.guid
inner join
sys_user t4
on t1.user_id=t4.user_id
where t1.guid='{commuTaskGuid}' and t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and t4.del_flag='0'
order by t1.id