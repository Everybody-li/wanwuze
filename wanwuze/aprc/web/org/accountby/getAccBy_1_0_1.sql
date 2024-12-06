-- ##Title web-查询机构名称信息列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询机构名称信息列表
-- ##CallType[QueryData]

-- ##input orgGuid char[36] NOTNULL;机构名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t1.account_by as targetUserId
,t2.user_name as userName
,t2.nick_name as nickName
,t2.nation
,t2.phonenumber
,left(t1.account_time,16) as accountTime
from 
coz_org_info t1
inner join
sys_user t2
on t1.account_by=t2.user_id
where t1.guid='{orgGuid}'
