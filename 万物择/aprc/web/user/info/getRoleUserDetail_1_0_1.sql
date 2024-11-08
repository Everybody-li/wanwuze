-- ##Title web-查询各类角色用户管理列表-用户账号信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询各类角色用户管理列表-用户账号信息
-- ##CallType[QueryData]

-- ##input userId string[50] NOTNULL;用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output userId int[>=0] 10;
-- ##output userName string[50] 用户账号;用户账号
-- ##output accountStatus string[1] 1;账号状态（0-开启，1-停用）
-- ##output roleName string[30] 角色名称;角色名称
-- ##output avatar string[200] 用户头像;用户头像
-- ##output password string[100] 用户密码;用户密码

select
t.user_id as userId
,t1.user_name as userName
,t1.status as accountStatus
,t2.role_name as roleName
,t1.avatar
,t1.password
,t1.nick_name as nickName
,t1.nation
,t1.phonenumber
,t1.create_time as createTime
from
sys_user_role t
left join
sys_user t1
on t1.user_id=t.user_id
left join
sys_role t2
on t2.role_id=t.role_id
where t1.user_id='{userId}' and t1.del_flag='0'
order by t1.create_time
