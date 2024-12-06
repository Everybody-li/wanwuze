-- ##Title web-沟通派发任务到期回收定时任务脚本
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-沟通派发任务到期回收定时任务脚本
-- ##CallType[ExSql]

update coz_serve2_commu_task t1
inner join coz_serve2_commu_task_tobject t2 
on t1.guid=t2.commu_task_guid
set 
t2.result='5'
,t2.result_time=now()
,t2.result_remark='系统定时回收'
,t1.expire_read_flag='1'
,t1.expire_read_time=now()
,t1.update_by='{curUserId}'
,t1.update_time=now()
,t2.update_by='{curUserId}'
,t2.update_time=now()
where t2.result='0' and left(t1.end_date,10)=date_sub(curdate(),INTERVAL 1 DAY)