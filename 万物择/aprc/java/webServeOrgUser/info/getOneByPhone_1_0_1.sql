-- ##Title 服务机构用户-根据手机号查询用户
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 服务机构用户-根据手机号查询用户
-- ##CallType[QueryData]

-- ##input phonenumber string[11] NOTNULL;手机号码，必填


select 
t.guid
,t.user_name as userName
,t.phonenumber
,t.status
from
coz_serve_org t
where t.phonenumber='{phonenumber}' and del_flag='0' and (t.user_name='{userName}' or replace(replace('{userName}','userName',''),'{}','')='')