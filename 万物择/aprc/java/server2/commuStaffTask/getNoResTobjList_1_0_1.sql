-- ##Title web-查询未进行沟通结果操作的用户列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询未进行沟通结果操作的用户列表
-- ##CallType[QueryData]


-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t2.guid as commuTaskTobjGuid
,t2.commu_task_guid as commuTaskGuid
,t2.object_guid as objectGuid
,t3.phonenumber
from 
coz_serve2_commu_task t1
inner join
coz_serve2_commu_task_tobject t2
on t1.guid=t2.commu_task_guid
inner join
coz_target_object t3
on t3.guid=t2.object_guid
where 
(t3.phonenumber  in ({phonenumber})) and t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and t2.result='0'and t1.start_date<=left(now(),10)
and t1.end_date>=left(now(),10)
