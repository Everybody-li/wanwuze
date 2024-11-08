-- ##Title web-查询供应专员的供应机构列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供应专员的供应机构列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input gyv2UserId string[36] NOTNULL;供应专员用户id，必填
-- ##input orgName string[30] NULL;机构名称(模糊搜索)，非必填

PREPARE p1 FROM '
select
t1.guid as orgStalogST2Guid
,t2.user_id as orgUserId
,t2.guid as orgGuid
,t2.name as orgName
,left(t2.create_time,16) as registerTime
,left(t1.create_time,16) as relateTime
from
coz_org_gyv2_relate_staff_log t1
inner join
coz_org_info t2
on t1.org_user_id=t2.user_id
where
t1.staff_type=''2'' and t1.detach_flag=''0'' and t1.staff_user_id=''{gyv2UserId}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and (t2.name like ''%{orgName}%'' or ''{orgName}''='''') 
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;