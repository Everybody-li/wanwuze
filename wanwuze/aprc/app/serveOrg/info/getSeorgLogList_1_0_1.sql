-- ##Title app-查询所在结算机构记录
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询所在结算机构记录
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select 
t1.user_name as orgName
,left(t2.create_time,16) as relateTime
,left(t2.detach_time,16) as dissolutionRelateTime
from 
coz_serve_org t1
inner join
coz_serve_org_relate_staff_log t2
on t1.guid=t2.seorg_guid
where t2.staff_user_id=''{curUserId}'' and t2.staff_type=''1'' and t1.del_flag=''0'' and t2.del_flag=''0'' and t2.detach_flag=''1''
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;