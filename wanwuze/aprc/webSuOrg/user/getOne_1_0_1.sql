-- ##Title web-获取机构用户个人信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 获取用户个人信息
-- ##CallType[QueryData]

-- ##input userId char[36] NOTNULL;用户id

-- ##output orgID string[18] 机构账号ID;机构账号ID

select 
t2.guid as orgGuid
,t1.guid as userId 
,t2.name as userName
,t2.name as userNick
,t1.phonenumber
,t1.avatar
,t1.status
,t1.nation
,t2.org_ID as orgID
,left(t1.create_time,19) as createTime
from
sys_weborg_user t1
inner join
coz_org_info t2
on t1.guid=t2.user_id
where t1.guid='{userId}'and t1.del_flag='0'