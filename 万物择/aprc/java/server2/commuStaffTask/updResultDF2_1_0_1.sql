-- ##Title web-更新沟通结果操作_草稿状态
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-更新沟通结果操作_草稿状态
-- ##CallType[ExSql]

-- ##input commuTaskTobjGuid char[36] NOTNULL;退货guid，必填
-- ##input result string[1] NOTNULL;沟通操作结果(1-接受服务，2-拒绝服务，3-未接通，4-无效号码)，必填
-- ##input resultRemark string[200] NULL;沟通操作结果(1-接受服务，2-拒绝服务，3-未接通，4-无效号码)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_serve2_commu_task_tobject t1
inner join
coz_serve2_commu_task t2
on t1.commu_task_guid=t2.guid
set 
t1.del_flag='2'
,t1.result='{result}'
,t1.result_time=now()
,t1.result_remark='{resultRemark}'
,t1.update_by='{curUserId}'
,t1.update_time=now()
where t1.guid='{commuTaskTobjGuid}' and (t1.result='0') and left(t2.end_date,10)>=left(now(),10)
;
