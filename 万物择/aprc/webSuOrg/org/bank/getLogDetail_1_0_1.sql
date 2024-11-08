-- ##Title web-供应-结算账号-查看更新详情
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-06-11
-- ##Describe web-供应-结算账号-查看更新详情
-- ##CallType[QueryData]

-- ##input logGuid char[36] NOTNULL;更新日志guid，必填
-- ##input curUserId string[36] NOTNULL;用户id

select
left(t2.create_time,16) as updateTime
,t1.phonenumber
,t2.bank_user_name as bankUserName
,t2.bank_name as bankName
,t2.bank_user_no as bankUserNo
,t2.bank_addr as bankAddr
from
coz_org_bank_log t2
inner join
coz_org_info t1
on t2.org_guid=t1.guid
where 
t2.guid='{logGuid}'