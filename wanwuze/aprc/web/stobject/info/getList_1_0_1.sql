-- ##Title web-查询个人用户信息管理
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询个人用户信息管理
-- ##CallType[QueryData]

-- ##input phonenumber string[50] NULL;机构名称(模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select 
t.guid as objectGuid
,t.user_id as userGuid
,t.name as objName
,left(t.create_time,16) as createTime
,t.phonenumber
,case when(t1.del_flag=''0'') then ''2'' when(t1.del_flag=''2'') then ''3'' else ''1'' end as userStatus
from 
coz_target_object t
left join
sys_app_user t1
on t.user_id=t1.guid
where 
(t.phonenumber like''%{phonenumber}%'' or ''{phonenumber}''='''') and t.del_flag=''0''
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;