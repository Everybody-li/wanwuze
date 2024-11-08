-- ##Title app-供应-查询订单验收通过结算详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-查询订单验收通过结算详情
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orderFeeSettleGuid char[36] NULL;品类类型guid，必填

-- ##output fee int[>=0] 0;结算金额(后端除以100保留2位小数)
-- ##output gainPayFlag int[>=0] 0;款项支付标志（0：未支付，其他值：已支付）
-- ##output payTime string[10] 0000年-00月-00日;款项支付时间（0000年-00月-00日）
-- ##output payProve string[600] 款项支付证明图片;款项支付证明图片，多个逗号隔开
-- ##output payRemark string[200] 款项支付说明;款项支付说明

select
cast(t.fee/100 as decimal(18,2)) as fee
,t.pay_type as gainPayFlag
,concat(left(t.pay_time,4),'年',right(left(t.pay_time,7),2),'月',right(left(t.pay_time,10),2),'日') as payTime
,t.pay_prove as payProve
,t.pay_remark as payRemark
from
coz_order_fee_settle t
where 
t.guid='{orderFeeSettleGuid}' and t.del_flag=0 and t.type=1