-- ##Title web-查询供应专员关联记录列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供应专员关联记录列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input orgUserId char[36] NULL;机构用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
t2.user_name as userName
,t2.nick_name as nickName
,t2.nation
,t2.phonenumber
,left(t2.create_time,16) as registerTime
,left(t1.create_time,16) as relateTime
,left(t1.detach_time,16) as detachTime
from
coz_org_gyv2_relate_staff_log t1
inner join
sys_user t2
on t1.staff_user_id=t2.user_id
where t1.del_flag=''0'' and t1.staff_type=''2'' and t1.org_user_id=''{orgUserId}''
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

