-- ##Title app-采购/供应-提供违约费用缴纳证明
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购/供应-提供违约费用缴纳证明
-- ##CallType[ExSql]

-- ##input judgeFeeGuid char[36] NOTNULL;违约费用guid，必填
-- ##input payProve string[600] NOTNULL;缴纳证明图片，多个逗号隔开，必填
-- ##input bizRuleGuid char[36] NOTNULL;违约费用缴纳规则guid
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @bizRuleName=(select name from coz_order_bussiness_rule where guid='{bizRuleGuid}')
;
update coz_order_judge_fee
set 
pay_prove='{payProve}'
,biz_rule_guid='{bizRuleGuid}'
,biz_rule_name=@bizRuleName
,pay_type='3'
,pay_time=now()
,update_by='{curUserId}'
,update_time=now()
where guid='{judgeFeeGuid}' 