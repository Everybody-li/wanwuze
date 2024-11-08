-- ##Title web-查询服务专员团队管理列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务专员团队管理列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input seorgGuid char[36] NOTNULL;服务机构guid，必填
-- ##input phonenumber string[50] NULL;品类名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填



PREPARE p1 FROM '
select
*
,(select count(1) from coz_serve_order_kpi where supply_gauser_id=t.staff_user_id and del_flag=''0'') as orderNum
from
(
select
t.staff_user_id as userGuid
,t.seorg_guid as seorgGuid
,left(t1.create_time,16) as openingTime
,t1.user_name as userName
,t1.nick_name as nickName
,t1.nation
,t1.phonenumber
,t.staff_user_id
from
coz_serve_org_relate_staff t
inner join
sys_user t1
on t.staff_user_id=t1.user_id
where t1.del_flag=''0'' and t.del_flag=''0'' and t.staff_type=''2'' and t.seorg_guid=''{seorgGuid}'' and (t1.user_name like ''%{phonenumber}%'' or t1.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
)t
group by t.userGuid,t.seorgGuid,t.openingTime,t.userName,t.nickName,t.nation,t.phonenumber,t.staff_user_id
order by t.openingTime desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

