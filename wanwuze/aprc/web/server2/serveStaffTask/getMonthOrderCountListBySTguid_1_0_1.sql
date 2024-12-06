-- ##Title web-查看服务专员的派发批次采购支付订单统计列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看服务专员的派发批次采购支付订单统计列表
-- ##CallType[QueryData]

-- ##input sdPName string[50] NULL;服务名称(模糊搜索)，非必填
-- ##input month string[7] NOTNULL;月份(格式：0000-00)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
*
from
(
select 
t3.guid as serveTaskGuid
,concat(left(t3.start_date,10),''---'',left(t3.end_date,10)) as taskTime
,left(t3.create_time,10) as AssignDate
,t3.target_object_num as targetObjectNum
,t4.name as sdPName
,(select count(1) from coz_order_serve2_source t1 inner join coz_serve2_serve_task_tobject t2 on t1.serve_task_tobject_guid=t2.guid where t2.serve_task_guid=t3.guid and t1.serve_staff_user_id=''{curUserId}''and left(t1.create_time,7)=''{month}'' and t2.del_flag=''0'') as orderPayNum
,t3.id
from 
coz_serve2_serve_task t3
inner join
coz_cattype_sd_path t4
on t3.sd_path_guid=t4.guid
where 
t3.del_flag=''0'' and t4.del_flag=''0'' and (t4.name like ''%{sdPName}%'' or ''{sdPName}''='''')
) t
where t.orderPayNum>0
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;