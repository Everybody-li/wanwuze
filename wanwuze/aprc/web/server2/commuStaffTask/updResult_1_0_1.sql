-- ##Title web-更新沟通结果操作
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-更新沟通结果操作
-- ##CallType[ExSql]

-- ##input commuTaskObjectGuid char[36] NOTNULL;退货guid，必填
-- ##input result string[1] NOTNULL;退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @flag1=(select case when exists(select 1 from coz_serve2_commu_task t1 inner join coz_serve2_commu_task_tobject t2
 on t1.guid=t2.commu_task_guid where t2.guid='{commuTaskObjectGuid}' and t1.del_flag='0' and t2.del_flag='0' and left(t1.end_date,10)<left(now(),10)) then '0' else '1' end)
;
set @flag2=(select case when exists(select 1 from coz_serve2_commu_task t1 inner join coz_serve2_commu_task_tobject t2
 on t1.guid=t2.commu_task_guid where t2.guid='{commuTaskObjectGuid}' and t1.del_flag='0' and t2.del_flag='0' and t2.result<>'0') then '0' else '1' end)
;
update coz_serve2_commu_task_tobject
set result='{result}'
,result_time=now()
,result_remark='{resultRemark}'
,update_by='{curUserId}'
,update_time=now()
where guid='{commuTaskObjectGuid}' and (result='0') and @flag1='1' and @flag2='1'
;
select 
case when(@flag1='1' and @flag2='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '当前沟通任务已到期，请到沟通任务派发-执行中进行核查！' when(@flag2='0') then '当前沟通任务已进行结果操作，请勿重复操作！' else '操作成功' end as msg
;