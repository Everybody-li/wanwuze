-- ##Title web-查询仲裁申请情况-订单取消
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询仲裁申请情况-订单取消
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t3.name as categoryName
,t3.img as categoryImg
,t3.alias as categoryAlias
,left(t2.create_time,10) as orderDate
,t2.order_no as orderNo
,left(t1.create_time,10) as applyDate
,t1.reason as reason
,t1.biz_rule_type1 as bizRuleType1
,(select name from coz_order_bussiness_rule where guid=t1.biz_rule_type1) as bizRuleType1Name
,t1.biz_rule_type21 as bizRuleType21
,(select name from coz_order_bussiness_rule where guid=t1.biz_rule_type21) as bizRuleType21Name
from 
coz_order_judge t
left join 
coz_order_cancel t1
on t.biz_guid=t1.guid 
left join 
coz_order t2 
on t1.order_guid=t2.guid 
left join 
coz_category_info t3
on t2.category_guid=t3.guid 
where 
t2.guid='{orderGuid}'

