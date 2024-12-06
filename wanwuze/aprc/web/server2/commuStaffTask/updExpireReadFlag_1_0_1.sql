-- ##Title web-修改沟通任务到期阅读标志
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-修改沟通任务到期阅读标志
-- ##CallType[ExSql]

-- ##input commuTaskGuid char[36] NOTNULL;沟通任务guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_serve2_commu_task
set expire_read_flag='2'
,expire_read_time=now()
,update_by='{curUserId}'
,update_time=now()
where guid='{commuTaskGuid}' and (expire_read_flag='0' or expire_read_flag='1')
;
update coz_serve2_commu_task_tobject
set result='5'
,result_time=now()
,result_remark='用户阅读到期标志触发收回'
,update_by='{curUserId}'
,update_time=now()
where commu_task_guid='{commuTaskGuid}' and (result='0')

