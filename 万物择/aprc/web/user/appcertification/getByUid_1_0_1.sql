-- ##Title web-查看实名认证信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-06-11
-- ##Describe web-查看实名认证信息
-- ##CallType[QueryData]

-- ##input userId char[36] NOTNULL;用户id
-- ##input curUserId string[36] NOTNULL;登录用户id

select
guid as certiGuid
,realname
,ID_type as idType
,ID_number as idNumber
,left(effective_start_date,10) as effectiveStartDate
,left(effective_end_date,10) as effectiveEndDate
,issuance_organ as issuanceOrgan
,imgs
from
coz_app_user_certification
where 
user_id='{userId}' and del_flag='0'