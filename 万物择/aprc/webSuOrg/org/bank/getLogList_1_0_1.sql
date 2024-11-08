-- ##Title web-供应-结算账号-查看更新记录
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-06-11
-- ##Describe web-供应-结算账号-查看更新记录
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id

select
guid as logGuid
,left(create_time,16) as updateTime
from
coz_org_bank_log
where 
user_id='{curUserId}' and del_flag='0'
order by create_time desc