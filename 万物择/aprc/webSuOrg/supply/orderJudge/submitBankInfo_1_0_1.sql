-- ##Title app-采购/供应-交易赔偿办理-提交收款账号
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购/供应-交易赔偿办理-提交收款账号
-- ##CallType[ExSql]

-- ##input judgeFeeGuid char[36] NOTNULL;订单guid，必填
-- ##input bankUserName string[50] NOTNULL;银行账户名称，必填
-- ##input bank string[50] NOTNULL;开户银行，必填
-- ##input bankNo string[50] NOTNULL;银行账号，必填
-- ##input bankAddr string[50] NOTNULL;银行地址，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_order_judge_fee
set 
bank_username='{bankUserName}'
,bank='{bank}'
,bank_no='{bankNo}'
,bank_addr='{bankAddr}'
,biz_rule_guid='c9b59c06-7374-11ec-a478-0242ac120003'
,biz_rule_name='违约赔偿缴纳规则'
,update_by='{curUserId}'
,update_time=now()
where guid='{judgeFeeGuid}' and pay_type='0' and confirm_pay_flag='1'