-- ##Title web-删除沟通结果操作草稿状态数据
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除沟通结果操作草稿状态数据
-- ##CallType[ExSql]

-- ##input commuTaskGuid char[36] NOTNULL;沟通任务guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_serve2_commu_task_tobject 
set 
del_flag='0'
,result='0'
,update_by='{curUserId}'
,update_time=now()
where commu_task_guid='{commuTaskGuid}' and del_flag='2'
;
