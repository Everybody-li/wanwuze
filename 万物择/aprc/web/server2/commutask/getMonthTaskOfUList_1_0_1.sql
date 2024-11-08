-- ##Title web-查看沟通调度专员处的沟通专员成果(个人月份详情列表)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看沟通调度专员处的沟通专员成果(个人月份详情列表)
-- ##CallType[QueryData]

-- ##input month string[7] NOTNULL;月份(格式：0000-00)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
phonenumber
,nickName
,userName
,month
,sum(targetObjectNum) as targetObjectNum
,sum(acceptService) as acceptService
,sum(refuseService) as refuseService
,sum(notConnected) as notConnected
,sum(invalidNumber) as invalidNumber
,sum(recovery) as recovery
from
(
select
concat(''(+86)'',t3.phonenumber) as phonenumber
,t3.nick_name as nickName
,t3.user_name as userName
,left(t1.create_time,7) as month
,t1.target_object_num as targetObjectNum
,ifnull((select count(1) as resultNum from coz_serve2_commu_task_tobject where del_flag=''0'' and result=''1'' and commu_task_guid=t1.guid group by result),0) as acceptService
,ifnull((select count(1) as resultNum from coz_serve2_commu_task_tobject where del_flag=''0'' and result=''2'' and commu_task_guid=t1.guid group by result),0) as refuseService
,ifnull((select count(1) as resultNum from coz_serve2_commu_task_tobject where del_flag=''0'' and result=''3'' and commu_task_guid=t1.guid group by result),0) as notConnected
,ifnull((select count(1) as resultNum from coz_serve2_commu_task_tobject where del_flag=''0'' and result=''4'' and commu_task_guid=t1.guid group by result),0) as invalidNumber
,ifnull((select count(1) as resultNum from coz_serve2_commu_task_tobject where del_flag=''0'' and result=''5'' and commu_task_guid=t1.guid group by result),0) as recovery
from 
coz_serve2_commu_task t1
inner join
sys_user t3
on t1.user_id=t3.user_id
where 
t1.del_flag=''0'' and t3.del_flag=''0'' and left(t1.create_time,7)=''{month}''and (t3.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
)t
group by phonenumber,nickName,userName,month
order by month
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;

