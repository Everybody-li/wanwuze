-- ##Title web-查询服务调度专员处的服务专员成果(月份详情列表)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务调度专员处的服务专员成果(月份详情列表)
-- ##CallType[QueryData]

-- ##input month string[7] NOTNULL;月份(格式：0000-00)，必填
-- ##input phonenumber string[11] NULL;联系电话，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
userName
,nickName
,phonenumber
,month
,sum(ifnull(targetObjectNum,0)) as targetObjectNum
,sum(ifnull(orderPayNum,0)) as orderPayNum
,sum(ifnull(activateAccountNum,0)) as activateAccountNum
from
(
select 
t3.user_name as userName
,t3.nick_name as nickName
,concat(''(+86)'',t3.phonenumber) as phonenumber
,left(t1.create_time,7) as month
,sum(t1.target_object_num) as targetObjectNum
,0 as orderPayNum
,0 as activateAccountNum
from 
coz_serve2_serve_task t1
inner join
sys_user t3
on t1.user_id=t3.user_id
where 
t1.del_flag=''0'' and t3.del_flag=''0'' and t3.status=''0'' and left(t1.create_time,7)=''{month}'' and (t3.phonenumber  like ''%{phonenumber}%'' or ''{phonenumber}''='''')
group by left(t1.create_time,7),t3.user_name,t3.nick_name,t3.phonenumber
union all
select 
t3.user_name as userName
,t3.nick_name as nickName
,concat(''(+86)'',t3.phonenumber) as phonenumber
,left(t5.create_time,7) as month
,0 as targetObjectNum
,count(t5.guid) as orderPayNum
,0 as activateAccountNum
from 
coz_serve2_serve_task t1
inner join
sys_user t3
on t1.user_id=t3.user_id
inner join
coz_serve2_serve_task_tobject t2
on t1.guid=t2.serve_task_guid
inner join
coz_order_serve2_source t5
on t2.guid=t5.serve_task_tobject_guid
where 
t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t3.status=''0'' and left(t5.create_time,7)=''{month}'' and (t3.phonenumber  like ''%{phonenumber}%'' or ''{phonenumber}''='''')
group by left(t5.create_time,7),t3.user_name,t3.nick_name,t3.phonenumber
union all
select 
t3.user_name as userName
,t3.nick_name as nickName
,concat(''(+86)'',t3.phonenumber) as phonenumber
,left(t4.account_time,7) as month
,0 as targetObjectNum
,0 as orderPayNum
,count(t4.guid) as activateAccountNum
from 
coz_org_info t4
inner join
sys_user t3
on t3.user_id=t4.account_by
where 
t3.del_flag=''0'' and t4.del_flag=''0'' and t3.status=''0'' and left(t4.account_time,7)=''{month}'' and (t3.phonenumber  like ''%{phonenumber}%'' or ''{phonenumber}''='''')
group by left(t4.account_time,7),t3.user_name,t3.nick_name,t3.phonenumber
)t
group by month,userName,nickName,phonenumber
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;