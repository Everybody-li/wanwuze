-- ##Title web-查询供应专员关联记录列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供应专员关联记录列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input orgUserGuid char[36] NULL;机构用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
*
from
(
select
t6.user_name as userName
,t6.nick_name as nickName
,t6.nation
,t6.phonenumber
,left(t6.create_time,16) as registerTime
,left(t2.create_time,16) as updateTime
,''关联'' as statusStr
,t5.user_name as seorgName
,left(t5.create_time,16) as seorgCreateTime
,t2.id
from
coz_org_info t1
inner join
coz_org_relate_staff_log t2
on t1.user_id=t2.org_user_id and t2.staff_type=''2''
inner join
coz_serve_org_relate_suorg t4
on t2.guid=t4.org_stalog_guid
inner join
coz_serve_org_relate_staff_log t3
on t3.guid=t4.seorg_stalog_guid
inner join
coz_serve_org t5
on t3.seorg_guid=t5.guid
inner join
sys_user t6
on t2.staff_user_id=t6.user_id
where t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t4.del_flag=''0'' and t5.del_flag=''0'' and t6.del_flag=''0'' and t2.staff_type=''2'' and t1.user_id=''{orgUserGuid}'' and t2.detach_flag=''0''
union all
select
t6.user_name as userName
,t6.nick_name as nickName
,t6.nation
,t6.phonenumber
,left(t6.create_time,16) as registerTime
,left(t2.create_time,16) as updateTime
,''解除'' as statusStr
,t5.user_name as seorgName
,left(t5.create_time,16) as seorgCreateTime
,t2.id
from
coz_org_info t1
inner join
coz_org_relate_staff_log t2
on t1.user_id=t2.org_user_id and t2.staff_type=''2''
inner join
coz_serve_org_relate_suorg t4
on t2.guid=t4.org_stalog_guid
inner join
coz_serve_org_relate_staff_log t3
on t3.guid=t4.seorg_stalog_guid
inner join
coz_serve_org t5
on t3.seorg_guid=t5.guid
inner join
sys_user t6
on t2.staff_user_id=t6.user_id
where t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t4.del_flag=''0'' and t5.del_flag=''0'' and t6.del_flag=''0'' and t2.staff_type=''2'' and t1.user_id=''{orgUserGuid}'' and t2.detach_flag=''1''
)t
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

