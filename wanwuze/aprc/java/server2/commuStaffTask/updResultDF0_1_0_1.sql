-- ##Title web-更新沟通结果操作_草稿状态
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-更新沟通结果操作_草稿状态
-- ##CallType[ExSql]

-- ##input commuTaskGuid char[36] NOTNULL;沟通任务guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_serve2_commu_task_tobject t1
inner join
coz_serve2_commu_task t2
on t1.commu_task_guid=t2.guid
set 
t1.del_flag='0'
,t1.update_by='{curUserId}'
,t1.update_time=now()
where t2.guid='{commuTaskGuid}' and (t1.del_flag='2') 
;
