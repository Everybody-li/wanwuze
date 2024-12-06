-- ##Title web-查看供方收款账号信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看供方收款账号信息
-- ##CallType[QueryData]

-- ##input judgeFeeGuid char[36] NOTNULL;裁决费用guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output judgeFeeGuid char[36] 裁决违约费用guid;裁决违约费用guid
-- ##output bankUserName string[20] 账户名称;账户名称
-- ##output bankName string[60] 开户银行;开户银行
-- ##output bankAccount string[600] 银行账号;银行账号
-- ##output bankAddr string[50] 银行地址;银行地址

select
t.guid as judgeFeeGuid
,t.bank_username as bankUserName
,t.bank as bankName
,t.bank_no as bankAccount
,t.bank_addr as bankAddr
,left(t.create_time,10) as createTime
from
coz_order_judge_fee t
where 
t.guid='{judgeFeeGuid}' and t.del_flag='0'