-- ##Title 查询app用户列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 查询app用户列表
-- ##CallType[QueryData]

-- ##input phonenumber string[11] NOTNULL;手机号码，必填
-- ##input userName string[30] NOTNULL;手机号码，必填

select 
t.user_id as guid
,t.user_id as userId
,t.name as userName
,t.phonenumber
,t.user_id as userld
,'0' as status
from
coz_org_info t
where t.phonenumber='{phonenumber}' and del_flag='0' and t.name = '{userName}'