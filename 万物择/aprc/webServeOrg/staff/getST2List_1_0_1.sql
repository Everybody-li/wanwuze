-- ##Title web-查询机构被授权的品类列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询机构被授权的品类列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input userName string[50] NULL;品类名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填



PREPARE p1 FROM '
select
t.staff_user_id as userGuid
,t.seorg_guid as seorgGuid
,t1.user_name as orgName
,left(t1.create_time,16) as openingTime
,t1.user_name as userName
,t1.nick_name as nickName
,t1.nation
,t1.phonenumber
,left(t.create_time,16) as createTime
,(select count(1) from coz_serve_order_kpi where supply_gauser_id=t.staff_user_id and del_flag=''0'') as orderNum
from
coz_serve_org_relate_staff t
inner join
sys_user t1
on t.staff_user_id=t1.user_id
where t1.del_flag=''0'' and t.del_flag=''0'' and t.staff_type=''2'' and t.seorg_guid=''{curUserId}'' and (t1.user_name like ''%{userName}%'' or t1.phonenumber like ''%{userName}%'' or ''{userName}''='''')
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

