-- ##Title app-查询订单取消申请详情(订单已取消)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询订单取消申请详情(订单已取消)
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NULL;订单guid
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output orderCancelTime string[10] 订单取消时间;订单取消时间（格式：0000年-00月-00日）
-- ##output reason string[200] 订单取消理由;订单取消理由
-- ##output bizRuleType1Guid char[36] 品类取消订单规则guid;品类取消订单规则guid
-- ##output bizRuleType1Name string[100] 品类取消订单规则;品类取消订单规则
-- ##output bizRuleType21Guid char[36] 退货裁决规则guid;退货裁决规则guid
-- ##output bizRuleType21Name string[100] 退货裁决规则;退货裁决规则

select 
t.order_guid as orderGuid
,concat(left(t.create_time,4),'年',right(left(t.create_time,7),2),'月',right(left(t.create_time,10),2),'日') as orderCancelTime
,t.reason
,t.biz_rule_type1 as bizRuleType1Guid
,(select name from coz_order_bussiness_rule where guid=t.biz_rule_type1) as bizRuleType1Name
,t.biz_rule_type21 as bizRuleType21Guid
,(select name from coz_order_bussiness_rule where guid=t.biz_rule_type21) as bizRuleType21Name
from 
coz_order_cancel t
where 
t.order_guid='{orderGuid}'