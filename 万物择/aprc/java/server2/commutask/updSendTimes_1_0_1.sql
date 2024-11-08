-- ##Title web-更新目标用户派发次数
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-更新目标用户派发次数
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input commuTaskGuid string[36] NOTNULL;沟通任务guid，必填


with t as (
    select send_times, object_guid
    from coz_serve2_commu_task_tobject
    where commu_task_guid = '{commuTaskGuid}'
)
update coz_serve2_commu_task_tobject t1 inner join t on t.object_guid = t1.object_guid
set t1.send_times=t.send_times + 1
where t1.del_flag = '0';
