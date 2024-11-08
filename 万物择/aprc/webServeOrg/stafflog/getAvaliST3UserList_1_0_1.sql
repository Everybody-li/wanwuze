-- ##Title web-查询可进行关联的招募专员列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询可进行关联的招募专员列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input phonenumber string[50] NULL;姓名或手机号(模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
left(t1.create_time,16) as registerTime
,t1.user_id as userId
,t1.user_name as userName
,t1.nick_name as nickName
,t1.nation
,t1.phonenumber
from
sys_user t1
inner join
sys_user_role t2
on t1.user_id=t2.user_id
inner join
sys_role t3
on t2.role_id=t3.role_id
where t1.del_flag=''0''  and t3.del_flag=''0'' and t3.role_key=''{zmhrRole}'' and (t1.user_name like ''%{phonenumber}%'' or t1.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''') and not exists(select 1 from coz_serve_org_relate_staff where staff_user_id=t1.user_id and del_flag=''0''  and staff_type=''3'')
order by t1.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

