-- ##Title 仲裁-更新仲裁费用支付情况_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 仲裁-更新仲裁费用支付情况_1_0_1
-- ##CallType[ExSql]

-- ##input judgeFeeGuid char[36] NOTNULL;仲裁费用guid，必填
-- ##input payNo string[50] NOTNULL;支付流水号
-- ##input payTime string[30] NOTNULL;支付时间
-- ##input payStatus string[1] NOTNULL;支付状态
-- ##input payType string[1] NOTNULL;支付类型

update coz_order_judge_fee
set pay_status={payStatus}
,pay_time='{payTime}'
,pay_no='{payNo}'
,pay_type='{payType}'
where guid='{judgeFeeGuid}'
