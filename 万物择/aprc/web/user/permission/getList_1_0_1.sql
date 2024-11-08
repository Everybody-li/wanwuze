-- ##Title web-查询用户列表（未封号用户/已封号用户）
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询用户列表（未封号用户/已封号用户）
-- ##CallType[QueryData]

-- ##input status int[>=0] NOTNULL;用户状态（0：未封号，1：已封号），必填
-- ##input phonenumber string[20] NULL;联系电话，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output categoryGuid char[36] 用户id;用户id
-- ##output categoryName string[50] 用户姓名;用户姓名
-- ##output nation string[50] 区号;区号
-- ##output phonenumber string[50] 用户电话号码;用户电话号码
-- ##output userTag int[>=0] 1;用户角色类型

PREPARE q1 FROM '
select
t1.guid as userId
,t1.user_name as userName
,t1.nation as nation
,t1.phonenumber as phonenumber
,t1.user_tag as userTag
,left(t1.create_time,16) as createTime
from
sys_app_user t1
where 
(t1.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''') and t1.status={status} and del_flag=0
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;

