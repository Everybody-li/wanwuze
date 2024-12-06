-- ##Title web-查询服务材料收集管理
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务材料收集管理
-- ##CallType[QueryData]

-- ##input sdPName string[50] NULL;机构名称(模糊搜索)，非必填
-- ##input startDate string[50] NULL;合同开始日期(格式：0000-00-00)，必填
-- ##input endDate string[10] NULL;合同终止日期(格式：0000-00-00)，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select 
t1.guid as serveTaskGuid
,t2.guid as serveTaskTobjectGuid
,t3.guid as serveTaskTobjectResultGuid
,t1.user_id as userId
,t1.pfelang_guid as pfelangGuid
,concat(left(t1.start_date,10),''---'',left(t1.end_date,10)) as taskTime
,t6.name as sdPName
,t4.name as objectName
,concat(''(+86)'',t4.phonenumber) as phonenumber
,t5.org_name as orgName
,t5.r_type as roleType
,t5.org_type as orgType
,t5.register_city as registerCity
,case when (exists(select 1 from coz_serve2_serve_task_tobject_sdp where serve_task_tobject_guid=t2.guid)) then ''1'' else ''0'' end as hasSDPFlag
from 
coz_serve2_serve_task t1
inner join
coz_serve2_serve_task_tobject t2
on t1.guid=t2.serve_task_guid
inner join
coz_serve2_serve_task_tobject_result t3
on t2.guid=t3.serve_task_tobject_guid
inner join
coz_target_object t4
on t2.object_guid=t4.guid
inner join
coz_target_object_org t5
on t4.guid=t5.object_guid
inner join
coz_cattype_sd_path t6
on t1.sd_path_guid=t6.guid
where 
(t4.phonenumber like''%{sdPName}%'' or t5.org_name like''%{sdPName}%'' or t6.name like''%{sdPName}%'' or ''{sdPName}''='''') and t1.user_id=''{curUserId}''and t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t4.del_flag=''0'' and t5.del_flag=''0'' and t6.del_flag=''0'' and t3.progress=''1'' and t3.result=''1'' and not exists(select 1 from coz_serve2_serve_task_tobject_result where serve_task_tobject_guid=t2.guid and progress<>''1'' and del_flag=''0'')
{dynamic:startDate[and t1.start_date>=''{startDate}'']/dynamic}
{dynamic:endDate[and t1.end_date<=''{endDate}'']/dynamic} 
and ((''{startDate}''<=''{endDate}'') or (''{startDate}''='''' and ''{endDate}''=''''))
and t1.start_date<=left(now(),10)
and t1.end_date>=left(now(),10)
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;