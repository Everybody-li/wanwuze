-- ##Title 机构用户-查询用户
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 机构用户-查询用户
-- ##CallType[QueryData]

-- ##input phonenumber string[11] NOTNULL;登录用户id，必填


select 
t.phonenumber
,t.user_id as userId
,t.name
from 
coz_org_info t
where 
phonenumber='{phonenumber}' and t.del_flag='0'
