-- ##Title web-查询沟通任务派发管理-执行中
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询沟通任务派发管理-执行中
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
,t1.user_id as userId
,concat(left(t1.start_date,10),''---'',left(t1.end_date,10)) as taskTime
,left(t1.create_time,16) as AssignDate
,t1.target_object_num as targetObjectNum
,t2.name as sdPName
from 
coz_serve2_serve_task t1
inner join
coz_cattype_sd_path t2
on t1.sd_path_guid=t2.guid
where 
(t2.name like''%{sdPName}%'' or ''{sdPName}''='''') and t1.del_flag=''0'' and t2.del_flag=''0'' 
{dynamic:startDate[and t1.start_date>=''{startDate}'']/dynamic}
{dynamic:endDate[and t1.end_date<=''{endDate}'']/dynamic} 
and ((''{startDate}''<=''{endDate}'') or (''{startDate}''='''' and ''{endDate}''=''''))
and t1.start_date<=left(now(),10)
and t1.end_date>=left(now(),10)
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;