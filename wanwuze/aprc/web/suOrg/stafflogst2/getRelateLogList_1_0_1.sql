-- ##Title web-查询供应机构关联记录
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供应机构关联记录
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input orgName string[50] NULL;机构名称（模糊搜索），非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
*
from
(
select
t1.name as orgName
,left(t1.create_time,16) as registerTime
,left(t.create_time,16) as relateTime
,''关联'' as statusStr
,t.id
from
coz_org_relate_staff_log t
inner join
coz_org_info t1
on t1.user_id=t.org_user_id
where t.del_flag=''0'' and t1.del_flag=''0'' and t.staff_type=''2'' and t.detach_flag=''0'' and t.staff_user_id=''{curUserId}'' and (t1.name like ''%{orgName}%'' or ''{orgName}''='''')
union all
select
t1.name as orgName
,left(t1.create_time,16) as registerTime
,left(t.detach_time,16) as relateTime
,''解除'' as statusStr
,t.id
from
coz_org_relate_staff_log t
inner join
coz_org_info t1
on t1.user_id=t.org_user_id
where t1.del_flag=''0'' and t.del_flag=''0'' and t.staff_type=''2'' and t.detach_flag=''1'' and t.staff_user_id=''{curUserId}'' and (t1.name like ''%{orgName}%'' or ''{orgName}''='''')
)t
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

