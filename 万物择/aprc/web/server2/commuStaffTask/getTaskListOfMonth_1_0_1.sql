-- ##Title web-查看沟通专员成果-查看详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看沟通专员成果-查看详情
-- ##CallType[QueryData]

-- ##input sdPathName string[50] NULL;机构名称(模糊搜索)，非必填
-- ##input month string[7] NOTNULL;月份(格式：0000-00)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select 
t1.guid as commuTaskGuid
,t1.user_id as userId
,concat(left(t1.start_date,10),''---'',left(t1.end_date,10)) as taskTime
,left(t1.create_time,16) as AssignDate
,t1.target_object_num as targetObjectNum
,t2.name as sdPName
,t1.pfelang_guid as pfelangGuid
from 
coz_serve2_commu_task t1
inner join
coz_cattype_sd_path t2
on t1.sd_path_guid=t2.guid
where 
(t2.name like''%{sdPathName}%'' or ''{sdPathName}''='''') and t1.del_flag=''0'' and t2.del_flag=''0'' and t1.user_id=''{curUserId}'' and left(t1.create_time,7)=''{month}''
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;