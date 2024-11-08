-- ##Title web-更新目标用户派发次数
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-更新目标用户派发次数
-- ##CallType[ExSql]

with t as (
    select t2.send_times, t2.object_guid
    from coz_serve2_commu_task t1 
inner join coz_serve2_commu_task_tobject t2 on t1.guid = t2.commu_task_guid
    where left(t1.end_date,10)=date_sub(curdate(),INTERVAL 1 DAY) and t1.del_flag='0'
)
update coz_serve2_commu_task_tobject t1 inner join t on t.object_guid = t1.object_guid
set t1.send_times=t.send_times + 1
where t1.del_flag = '0';