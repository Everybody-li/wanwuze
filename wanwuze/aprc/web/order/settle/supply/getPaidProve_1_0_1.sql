-- ##Title web-查看付款证明
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看付款证明
-- ##CallType[QueryData]

-- ##input settleGuid char[36] NOTNULL;结算guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output settleGuid char[36] 结算guid;结算guid
-- ##output settleTime string[10] 0000-00-00;提交（结算）日期（格式：0000-00-00）
-- ##output prove string[600] 付款证明图片;付款证明图片，多个逗号隔开
-- ##output remark string[50] 付款说明;付款说明

select
t.guid as settleGuid
,left(t.pay_time,10) as settleTime
,t.pay_prove as prove
,t.pay_remark as remark
from
coz_order_fee_settle t
where 
t.guid='{settleGuid}' and t.del_flag='0'