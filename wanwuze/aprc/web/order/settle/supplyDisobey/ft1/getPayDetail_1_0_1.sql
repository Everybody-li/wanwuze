-- ##Title web-结算管理-查看供方付款证明
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-结算管理-查看供方付款证明
-- ##CallType[QueryData]

-- ##input judgeFeeGuid char[36] NOTNULL;裁决费用guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output payTime string[10] 0000-00-00;供方提交付款证明时间（格式：0000-00-00）
-- ##output payProve string[600] 供方提交付款证明图片;供方提交付款证明图片，多个逗号隔开
-- ##output bizRuleGuid char[36] 适用规则guid;适用规则guid
-- ##output bizRuleName string[50] 适用规则name;适用规则name

select
left(t.pay_time,10)as payTime
,t.pay_prove as payProve
,t.biz_rule_guid as bizRuleGuid
,t.biz_rule_name as bizRuleName
from
coz_order_judge_fee t
where 
t.guid='{judgeFeeGuid}' and t.del_flag='0'