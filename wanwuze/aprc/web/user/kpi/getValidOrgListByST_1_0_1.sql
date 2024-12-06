-- ##Title web-供应专员-查询权限供应机构列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-供应专员-查询权限供应机构列表
-- ##CallType[QueryData]

-- ##input staffUserId char[36] NOTNULL;用户id(登录用户id)，必填
-- ##input orgName string[50] NULL;供应机构名称(模糊搜索)，非必填
-- ##input staffType string[1] NOTNULL;业务专员用户类型（2-供应专员，3-招募专员），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
t2.guid as seorgGuid
,t2.name as seorgName
,left(t1.create_time,16) as relateTime
,left(t2.create_time,16) as registerTime
from
coz_org_relate_staff t1
inner join
coz_org_info t2
on t1.org_user_id=t2.user_id
where
t1.staff_type=''{staffType}'' and t1.staff_user_id=''{staffUserId}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and (t2.name like ''%{orgName}%'' or ''{orgName}''='''')
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;