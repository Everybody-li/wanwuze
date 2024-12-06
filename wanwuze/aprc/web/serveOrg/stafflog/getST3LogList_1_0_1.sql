-- ##Title web-查询授权品类更新记录列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询授权品类更新记录列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input seorgName string[50] NULL;品类名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
*
from
(
select
t1.user_name as seorgName
,left(t1.create_time,16) as registerTime
,left(t.create_time,16) as relateTime
,''关联'' as statusStr
,t.id
from
coz_serve_org_relate_staff_log t
inner join
coz_serve_org t1
on t.seorg_guid=t1.guid
where t1.del_flag=''0'' and t.del_flag=''0'' and t.staff_type=''3'' and t.detach_flag=''0'' and t.staff_user_id=''{curUserId}'' and (t1.user_name like ''%{seorgName}%'' or ''{seorgName}''='''')
union all
select
t1.user_name as seorgName
,left(t1.create_time,16) as registerTime
,left(t.update_time,16) as relateTime
,''解除'' as statusStr
,t.id
from
coz_serve_org_relate_staff_log t
inner join
coz_serve_org t1
on t.seorg_guid=t1.guid
where t1.del_flag=''0'' and t.del_flag=''0'' and t.staff_type=''3'' and t.detach_flag=''1'' and t.staff_user_id=''{curUserId}'' and (t1.user_name like ''%{seorgName}%'' or ''{seorgName}''='''')
)t
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

