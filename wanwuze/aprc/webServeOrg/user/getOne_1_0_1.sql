-- ##Title web-获取机构用户个人信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 获取用户个人信息
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input seorgGuid char[36] NOTNULL;机构guid，必填

select 
t.guid as userId 
,t.user_name as userName
,t.phonenumber
,t.avatar
,t.status
,t.nation
,left(t.create_time,19) as createTime
from
coz_serve_org t
where t.guid='{seorgGuid}'and del_flag='0'