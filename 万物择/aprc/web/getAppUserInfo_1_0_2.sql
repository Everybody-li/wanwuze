-- ##Title web-查询个人账号信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询个人账号信息
-- ##CallType[QueryData]

-- ##input userId string[36] NOTNULL;用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
t.user_name as userName
,t.nick_name as nickName
,t.nation
,t.phonenumber
,left(t.create_time,16) as registerTime
from
sys_app_user t
where 
t.guid='{userId}' and t.del_flag='0'


