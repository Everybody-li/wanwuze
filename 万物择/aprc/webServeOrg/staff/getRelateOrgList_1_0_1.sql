-- ##Title web-查询供应专员的权限供应机构列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供应专员的权限供应机构列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input staffUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input orgName string[50] NULL;品类名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
left(t.create_time,16) as relateTime
,left(t1.create_time,16) as registerTime
,t1.name as orgName
from
coz_org_relate_staff t
inner join
coz_org_info t1
on t.org_user_id=t1.user_id
where t1.del_flag=''0'' and t.del_flag=''0'' and t.staff_user_id=''{staffUserId}'' and (t1.name like ''%{orgName}%'' or ''{orgName}''='''')
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

