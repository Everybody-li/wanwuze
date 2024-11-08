-- ##Title web-查询沟通任务的带搜索条件的目标用户列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询沟通任务的带搜索条件的目标用户列表
-- ##CallType[QueryData]

-- ##input phonenumber string[11] NULL;机构名称(模糊搜索)，非必填
-- ##input commuTaskGuid string[36] NOTNULL;沟通任务guid，必填
-- ##input result string[1] NULL;机构名称(模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select 
t1.commu_task_guid as commuTaskGuid
,t1.guid as commuTaskObjectGuid
,concat(''(+86)'',t2.phonenumber) as phonenumber
,t1.object_guid as objectGuid
,t1.result
,t2.name as nickName
,t3.org_name as orgName
,t3.r_type as roleType
,t3.org_type as orgType
,t3.register_city as registerCity
from 
coz_serve2_commu_task_tobject t1
inner join
coz_target_object t2
on t1.object_guid=t2.guid
inner join
coz_target_object_org t3
on t1.object_org_guid=t3.guid
where 
(t2.phonenumber like''%{phonenumber}%'' or t3.org_name like''%{phonenumber}%'' or ''{phonenumber}''='''') and t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and (t1.commu_task_guid=''{commuTaskGuid}'' or ''{commuTaskGuid}''='''') and (t1.result=''{result}'' or ''{result}''='''')
order by t2.id desc,t3.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;