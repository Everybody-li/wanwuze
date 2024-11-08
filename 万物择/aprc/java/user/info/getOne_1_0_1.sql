-- ##Title 查询app用户信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 查询app用户信息
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output userId char[36] 用户id;用户id
-- ##output userName string[30] 用户姓名;用户姓名
-- ##output userPhone string[30] 用户手机号;用户手机号

select 
t.guid as userId 
,t.user_name as userName
,t.phonenumber as userPhone
from
sys_app_user t
where t.guid = '{curUserId}' and del_flag='0' and status='0'