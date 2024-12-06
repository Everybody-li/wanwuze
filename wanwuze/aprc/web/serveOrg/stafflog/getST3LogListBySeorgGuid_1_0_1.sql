-- ##Title web-查询授权品类更新记录列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询授权品类更新记录列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input seorgGuid char[36] NULL;服务机构guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
*
from
(
select
t1.user_name as userName
,t1.nick_name as nickName
,t1.nation
,t1.phonenumber
,left(t1.create_time,16) as registerTime
,left(t.update_time,16) as updateTime
,''关联'' as statusStr
,t.id
from
coz_serve_org_relate_staff_log t
inner join
sys_user t1
on t.staff_user_id=t1.user_id
where t1.del_flag=''0'' and t.del_flag=''0'' and t.staff_type=''3'' and t.detach_flag=''0'' and t.seorg_guid=''{seorgGuid}''
union all
select
t1.user_name as userName
,t1.nick_name as nickName
,t1.nation
,t1.phonenumber
,left(t1.create_time,16) as registerTime
,left(t.update_time,16) as updateTime
,''解除'' as statusStr
,t.id
from
coz_serve_org_relate_staff_log t
inner join
sys_user t1
on t.staff_user_id=t1.user_id
where t1.del_flag=''0'' and t.del_flag=''0'' and t.staff_type=''3'' and t.detach_flag=''1'' and t.seorg_guid=''{seorgGuid}''
)t
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

