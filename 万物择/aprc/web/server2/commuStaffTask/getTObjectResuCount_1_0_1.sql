-- ##Title web-查询沟通任务的带搜索条件的目标用户列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询沟通任务的带搜索条件的目标用户列表
-- ##CallType[QueryData]


-- ##input commuTaskGuid string[36] NOTNULL;沟通任务guid，必填
-- ##input result string[1] NULL;机构名称(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
t.*
,case when(t.result='0') then '无' when(t.result='1') then '接受服务' when(t.result='2') then '拒绝服务' when(t.result='3') then '未接通' when(t.result='4') then '无效号码' when(t.result='5') then '时间到被收回' else '' end as resultStr
from
(
select 
t1.commu_task_guid as commuTaskGuid
,t1.result
,count(1) as resultCount
from 
coz_serve2_commu_task_tobject t1
where 
t1.del_flag='0' and t1.commu_task_guid='{commuTaskGuid}' and (t1.result='{result}' or '{result}'='')
group by t1.commu_task_guid,t1.result
)t
order by t.resultCount desc
