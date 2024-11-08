-- ##Title app-采购/供应-交易赔偿办理-赔偿详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购/供应-交易赔偿办理-赔偿详情
-- ##CallType[QueryData]

-- ##input judgeFeeGuid char[36] NULL;违约费用guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output judgeGuid char[36] 仲裁guid;仲裁guid
-- ##output judgeFeeGuid char[36] 违约费用guid;违约费用guid
-- ##output judgeFee decimal[>=0] 1;赔偿金额(后端除以100保留2位小数)
-- ##output submitBankTime string[10] 提交时间;提交时间（格式：0000年-00月-00日）
-- ##output bankUserName string[50] 银行账户名称;银行账户名称
-- ##output bank string[50] 开户银行;开户银行
-- ##output bankNo string[50] 银行账号;银行账号
-- ##output bankAddr string[200] 银行地址;银行地址
-- ##output bizRuleGuid char[36] 适用规则guid;适用规则guid
-- ##output bizRuleName string[50] 适用规则名称;适用规则名称
-- ##output judgePayTime string[10] 0000-00-00;违约费用缴纳时间（格式：0000-00-00）
-- ##output judgePayProve string[600] 违约费用缴纳证明图片;违约费用缴纳证明图片，多个逗号隔开
-- ##output judgePayRemark string[200] 提交付款说明;提交付款说明
-- ##output submitBankFlag string[1] 1;提交银行收款账号标志（0：未提交，1：已提交）
-- ##output gainPayFlag string[1] 1;赔偿款项支付标志（0：未支付，3：已支付）

select 
t.guid as judgeGuid
,t1.guid as judgeFeeGuid
,cast(t.disobey_fee/100 as decimal(18,2)) as judgeFee
,left(t1.submit_bank_time,10) as submitBankTime
,t1.bank_username as bankUserName
,t1.bank
,t1.bank_no as bankNo
,t1.bank_addr as bankAddr
,t1.biz_rule_guid as bizRuleGuid
,t1.biz_rule_name as bizRuleName
,left(t1.pay_time,10) as judgePayTime
,t1.pay_prove as judgePayProve
,t1.pay_remark as judgePayRemark
,case when(t1.bank='') then '0' else '1' end as submitBankFlag
,case when(t1.pay_type<>'3') then '0' else '3' end as gainPayFlag
from 
coz_order_judge_fee t1
left join 
coz_order_judge t
on t1.judge_guid=t.guid 
left join 
coz_order t3 
on t.order_guid=t3.guid 
left join 
coz_category_info t4
on t3.category_guid=t4.guid 
where 
t1.guid='{judgeFeeGuid}'

