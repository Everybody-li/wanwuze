-- ##Title app-查询(进入)取消订单页面
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询(进入)取消订单页面
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orderGuid char[36] NULL;订单guid

-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output orderNo string[24] 采购编号;采购编号
-- ##output orderTime string[10] 订单创建日期;订单创建日期（格式：0000-00-00）
-- ##output categoryGuid char[36] 品类guid;品类guid
-- ##output categoryImg string[50] 品类图片;品类图片
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output categoryalias string[50] 品类别名;品类别名，多个逗号隔开
-- ##output bizRuleType1Guid char[36] 品类取消订单规则guid;品类取消订单规则guid
-- ##output bizRuleType1Name string[100] 品类取消订单规则;品类取消订单规则
-- ##output bizRuleType21Guid char[36] 退货裁决规则guid;退货裁决规则guid
-- ##output bizRuleType21Name string[100] 退货裁决规则;退货裁决规则

select 
t2.guid as orderGuid
,t2.order_no as orderNo
,left(t2.create_time,10) as orderTime
,t3.guid as categoryGuid
,t3.img as categoryImg
,t3.name as categoryName
,t3.alias as categoryAlias
,t1.biz_rule_type1 as bizRuleType1Guid
,(select name from coz_order_bussiness_rule where guid=t1.biz_rule_type1) as bizRuleType1Name
,t1.biz_rule_type21 as bizRuleType21Guid
,(select name from coz_order_bussiness_rule where guid=t1.biz_rule_type21) as bizRuleType21Name
from 
coz_order_cancel t1
left join 
coz_order t2 
on t1.order_guid=t2.guid 
left join 
coz_category_info t3
on t2.category_guid=t3.guid 
where 
t2.supply_user_id='{curUserId}'and t2.guid='{orderGuid}'