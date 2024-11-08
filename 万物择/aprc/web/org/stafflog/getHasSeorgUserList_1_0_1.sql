-- ##Title web-查询可进行关联的供应专员列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询可进行关联的供应专员列表
-- ##CallType[QueryData]

-- ##input phonenumber string[50] NULL;姓名或手机号(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select 
t1.guid as seorgStalogGuid
,t1.staff_user_id as userId
,t3.user_name as userName
,t3.nick_name  as nickName
,t3.nation
,t3.phonenumber
,t2.user_name as seorgName
,left(t3.create_time,16) as registerTime
,left(t2.create_time,16) as relateTime
from 
coz_serve_org_relate_staff_log t1
inner join
coz_serve_org t2
on t2.guid=t1.seorg_guid
inner join
sys_user t3
on t1.staff_user_id=t3.user_id
where  t1.staff_type=''2'' and t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t1.detach_flag=''0''and (t3.user_name like ''%{phonenumber}%'' or t3.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''') 
order by t3.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;