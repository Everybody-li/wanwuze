-- ##Title web-查看付款证明
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看付款证明
-- ##CallType[QueryData]

-- ##input judgeFeeGuid char[36] NOTNULL;裁决费用guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output judgeFeeGuid char[36] 裁决违约费用guid;裁决违约费用guid
-- ##output confirmRefundPayProveTime string[10] 0000-00-00;提交（结算）日期（格式：0000-00-00）
-- ##output confirmRefundPayProve string[600] 付款证明图片;付款证明图片，多个逗号隔开
-- ##output confirmRefundPayRemark string[50] 付款说明;付款说明

select
t.guid as judgeFeeGuid
,left(t.confirm_pay_time,10) as confirmRefundPayProveTime
,t.pay_prove as confirmRefundPayProve
,t.pay_remark as confirmRefundPayRemark
from
coz_order_judge_fee t
where 
t.guid='{judgeFeeGuid}' and t.del_flag=0