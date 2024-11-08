-- ##Title web-供应-结算账号-查看详情
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-06-11
-- ##Describe web-供应-结算账号-查看详情
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id

select
t2.guid
,t2.bank_user_name as bankUserName
,t2.bank_name as bankName
,t2.bank_user_no as bankUserNo
,t2.bank_addr as bankAddr
from
coz_org_bank t2
where 
t2.user_id='{curUserId}'