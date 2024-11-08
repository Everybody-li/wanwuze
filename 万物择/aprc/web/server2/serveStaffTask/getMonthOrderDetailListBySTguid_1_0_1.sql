-- ##Title web-查看服务专员的派发批次采购支付订单详情列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看服务专员的派发批次采购支付订单详情列表
-- ##CallType[QueryData]

-- ##input phonenumber string[11] NULL;机构名称(模糊搜索)，非必填
-- ##input serveTaskGuid string[36] NOTNULL;沟通任务guid，必填
-- ##input month string[7] NOTNULL;月份(格式：0000-00) ，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select
serveTaskGuid
,serveTaskObjectGuid
,createTime
,demandUserId
,concat(''(+86)'',t.phonenumber) as phonenumber
,objectGuid
,nickName
,orgName
,roleType
,orgType
,registerCity
,orderNum
from
(
select 
t1.serve_task_guid as serveTaskGuid
,t1.guid as serveTaskObjectGuid
,left(t2.create_time,16) as createTime
,t5.demand_user_id as demandUserId
,t6.phonenumber as phonenumber
,t1.object_guid as objectGuid
,t6.nick_name as nickName
,t3.org_name as orgName
,t3.r_type as roleType
,t3.org_type as orgType
,t3.register_city as registerCity
,t2.id
,count(t4.guid) as orderNum
from 
coz_serve2_serve_task_tobject t1
inner join
coz_serve2_serve_task t2
on t1.serve_task_guid=t2.guid
inner join
coz_target_object_org t3
on t1.object_org_guid=t3.guid
inner join
coz_order_serve2_source t4
on t1.guid=t4.serve_task_tobject_guid
inner join
coz_order t5
on t4.order_guid=t5.guid
inner join
sys_app_user t6
on t5.demand_user_id=t6.guid
where 
(t6.phonenumber like''%{phonenumber}%'' or t3.org_name like''%{phonenumber}%'' or ''{phonenumber}''='''') and t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t5.del_flag=''0'' and t1.serve_task_guid=''{serveTaskGuid}''and left(t4.create_time,7)=''{month}'' and t4.serve_staff_user_id=''{curUserId}''
group by t1.serve_task_guid,t1.guid,left(t2.create_time,16),t5.demand_user_id,t6.phonenumber,t1.object_guid,t6.nick_name,t3.org_name,t3.r_type,t3.org_type,t3.register_city,t2.id
)t
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;