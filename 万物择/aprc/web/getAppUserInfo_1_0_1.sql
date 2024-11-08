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
,case when (t1.ID_type=1)  then '身份证' else '身份证' end as IDTypeStr
,t1.ID_number as IDNumber
,left(t1.effective_start_date,10) as effectiveStartDate
,left(t1.effective_end_date,10) as effectiveEndDate
,t1.issuance_organ as issuanceOrgan
,t1.imgs
from
sys_app_user t
left join
coz_app_user_certification t1
on t1.user_id=t.guid
where 
t.guid='{userId}' and t.del_flag='0'


