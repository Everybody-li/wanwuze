-- ##Title web-运营经理操作管理-交易对接管理-对接专员信息管理-列表上方-括号内数量
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 统计t3.角色权限字符串是duijieRole的用户数量
-- ##Describe sys_user t1,sys_user_role t2,sys_role t3
-- ##CallType[QueryData]

-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input roleKey string[50] NOTNULL;角色类型，必填

-- ##output totalNum int[>=0] ;对接专员数量


select 
count(1) as totalNum 
from 
sys_user t1
inner join
sys_user_role t2
on t1.user_id=t2.user_id
inner join
sys_role t3
on t2.role_id=t3.role_id
where 
t1.del_flag='0' and t3.del_flag='0' and t3.role_key='{roleKey}'