-- ##Title app-获取用户个人信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-获取用户个人信息
-- ##CallType[QueryData]

-- ##input userId char[36] NOTNULL;用户id

-- ##output userid char[36] 用户id;用户id
-- ##output username string[30] 用户姓名;用户姓名
-- ##output nation string[30] 用户区号;用户区号
-- ##output loginTime string[30] 登录时间戳;登录时间戳
-- ##output ipaddr string[30] 登录IP地址;登录IP地址
-- ##output phonenumber string[30] 用户手机号;用户手机号
-- ##output avatar string[200] 用户头像;用户头像
-- ##output status int[>=0] 10;用户账号状态（0：正常，1：停用）
-- ##output createTime string[19] 注册日期;注册日期
-- ##output userTag int[>=0] 10;角色类型


select 
t.guid as userId 
,t.user_name as username
,t.login_date as loginTime
,t.login_ip as ipaddr
,t.phonenumber
,t.avatar
,t.status
,t.nation
,left(t.create_time,19) as createTime
from
sys_app_user t
where t.guid='{userId}'and del_flag='0'