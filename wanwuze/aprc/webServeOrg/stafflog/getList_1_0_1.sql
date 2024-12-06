-- ##Title web-查询服务专员的变动记录
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务专员的变动记录
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input userName string[50] NULL;品类名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
*
from
(
select
t.guid as reStaffLogGuid
,t.staff_user_id as staffUserId
,t.seorg_guid as seorgGuid
,''加入机构'' as statusStr
,left(t.create_time,16) as createTime
,t1.user_name as orgName
,left(t1.create_time,16) as openingTime
,t1.user_name as userName
,t1.nation
,t1.phonenumber
,t.id
from
coz_serve_org_relate_staff_log t
inner join
sys_app_user t1
on t.staff_user_id=t1.guid
where t1.del_flag=''0'' and t.del_flag=''0'' and t.detach_flag=''0'' and t.seorg_guid=''{curUserId}''
union all
select
t.guid as reStaffLogGuid
,t.staff_user_id as staffUserId
,t.seorg_guid as seorgGuid
,''离开机构'' as statusStr
,left(t.create_time,16) as createTime
,t1.user_name as orgName
,left(t1.create_time,16) as openingTime
,t1.user_name as userName
,t1.nation
,t1.phonenumber
,t.id
from
coz_serve_org_relate_staff_log t
inner join
sys_app_user t1
on t.staff_user_id=t1.guid
where t1.del_flag=''0'' and t.del_flag=''0'' and t.detach_flag=''1'' and t.seorg_guid=''{curUserId}''
)t
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

