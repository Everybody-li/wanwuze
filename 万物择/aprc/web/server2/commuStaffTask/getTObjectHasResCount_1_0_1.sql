-- ##Title web-沟通结果按是否已操作统计数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-沟通结果按是否已操作统计数量
-- ##CallType[QueryData]

-- ##input commuTaskGuid char[36] NOTNULL;沟通任务guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
ifnull((select count(1) from coz_serve2_commu_task_tobject where del_flag='0' and result='0' and commu_task_guid='{commuTaskGuid}'),0) as noResCount
,ifnull((select count(1) from coz_serve2_commu_task_tobject where del_flag='0' and result<>'0' and commu_task_guid='{commuTaskGuid}'),0) as hasResCount
