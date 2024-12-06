-- ##Title web-结算专员操作管理-需方采购结算管理-需方退货退款支付-审批模式/交易模式-列表上方标签栏括号内数量统计
-- ##Author 卢文彪
-- ##CreateTime 2023-08-17
-- ##Describe 查询是供方取消的订单数量
-- ##CallType[QueryData]

-- ##input month string[7] NOTNULL;验收通过月份（格式：0000-00），必填
-- ##input mode enum[2,3] NOTNULL;品类模式：2-交易模式，3-审批模式
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output monthTotalCount int[>=0] 1;月份总数量



select
count(1) as monthTotalCount
from
coz_order_cancel t
left join
coz_order t1
on t.order_guid=t1.guid
left join
coz_category_info t2
on t1.category_guid=t2.guid
left join
coz_cattype_fixed_data t3
on t2.cattype_guid=t3.guid
where 
left(t.create_time,7)='{month}' and t.del_flag='0' and (t.cancel_object='2') and t3.mode={mode}
--  and t.refund_pay_status='2'

