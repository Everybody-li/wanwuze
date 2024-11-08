-- ##Title web-查看服务专员的派发批次采购支付订单详情-服务对象数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看服务专员的派发批次采购支付订单详情-服务对象数量
-- ##CallType[QueryData]

-- ##input serveTaskGuid string[36] NOTNULL;沟通任务guid，必填
-- ##input month string[7] NOTNULL;月份(格式：0000-00)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
count(t4.guid) as tobjectNum
from 
coz_order_serve2_source t1
inner join
coz_serve2_serve_task_tobject t2
on t1.serve_task_tobject_guid=t2.guid
inner join
coz_serve2_serve_task t3
on t2.serve_task_guid=t3.guid
inner join
coz_target_object_org t4
on t2.object_org_guid=t4.guid
where 
t2.del_flag='0' and t3.del_flag='0' and t4.del_flag='0' and t1.serve_staff_user_id='{curUserId}'  and t2.serve_task_guid='{serveTaskGuid}' and left(t1.create_time,7)='{month}'
