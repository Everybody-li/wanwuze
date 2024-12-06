-- ##Title web-查看服务专员的派发批次采购支付订单编号及品类信息列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看服务专员的派发批次采购支付订单编号及品类信息列表
-- ##CallType[QueryData]

-- ##input demandUserId string[36] NOTNULL;服务对象用户guid(需方用户id)，必填
-- ##input serveTaskGuid string[36] NOTNULL;沟通任务guid，必填
-- ##input month string[7] NOTNULL;月份(格式：0000-00) ，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select 
t1.serve_task_guid as serveTaskGuid
,left(t5.create_time,16) as createTime
,t5.order_no as orderNo
,t6.category_name as categoryName
,t6.cattype_name as cattypeName
from 
coz_serve2_serve_task_tobject t1
inner join
coz_serve2_serve_task t2
on t1.serve_task_guid=t2.guid
inner join
coz_order_serve2_source t4
on t1.guid=t4.serve_task_tobject_guid
inner join
coz_order t5
on t4.order_guid=t5.guid
inner join
coz_demand_request t6
on t5.request_guid=t6.guid
where 
t1.del_flag=''0'' and t2.del_flag=''0'' and t5.del_flag=''0'' and t6.del_flag=''0'' and t1.serve_task_guid=''{serveTaskGuid}''and left(t4.create_time,7)=''{month}'' and t4.serve_staff_user_id=''{curUserId}'' and t5.demand_user_id=''{demandUserId}''
order by t4.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;