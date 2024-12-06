-- ##Title web-查看沟通记录
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看沟通记录
-- ##CallType[QueryData]

-- ##input commuTaskObjectGuid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t1.result
,t1.result_remark as resultRemark
from 
coz_serve2_commu_task_tobject t1
where t1.guid='{commuTaskObjectGuid}'