-- ##Title web-更新沟通任务派发数据为正式状态
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-更新沟通任务派发数据为正式状态
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input commuTaskGuid string[36] NOTNULL;沟通任务guid，必填

update 
coz_serve2_commu_task t1 
inner join 
coz_serve2_commu_task_tobject t2
on t1.guid = t2.commu_task_guid
set t1.del_flag='0'
,t2.del_flag='0'
where t1.guid='{commuTaskGuid}' and t1.del_flag = '2' and t2.del_flag = '2';
