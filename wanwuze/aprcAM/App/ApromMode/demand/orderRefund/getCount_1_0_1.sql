-- ##Title app-管理-审批模式下的品类-费用结算管理-订单退款接收-查询总数量
-- ##Author 卢文彪
-- ##CreateTime 2023-08-08
-- ##Describe 统计当前采购供应路径下的需方自己的订单的退款数量，查询退款已支付的
-- ##Describe 表名： coz_order t1,coz_order_cancel t2
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output refundSupAcceptCount int[>0] NOTNULL;订单退款接收数量


select
count(1) as refundSupAcceptCount
from
coz_order t1
inner join
coz_order_cancel t2
on t1.guid=t2.order_guid
where 
t1.del_flag='0' and t2.del_flag='0' and t1.sd_path_guid='{sdPathGuid}' and t2.refund_pay_status='2' and t1.demand_user_id='{curUserId}'
