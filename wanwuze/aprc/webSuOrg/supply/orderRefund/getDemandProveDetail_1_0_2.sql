-- ##Title app-供应-查询需方退货证明
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-查询需方退货证明
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output bizRuleType23Guid char[36] 实物退货退款规则guid;实物退货退款规则guid
-- ##output bizRuleType23Name string[20] 实物退货退款规则名称;实物退货退款规则名称
-- ##output orderRefundGuid char[36] 订单退货guid;订单退货guid
-- ##output proveTime string[10] 0000-00-00;订单退货证据提交时间（格式：0000年-00月-00日）
-- ##output proveImgs string[600] 货证明图片;货证明图片（退货物流单子），多个逗号隔开
-- ##output proveSupplySignDate string[10] 0000-00-00;需方提供的供方签收日期
-- ##output proveSupplySignImgs string[600] 需方提供的供方签收证明图片;需方提供的供方签收证明图片，多个逗号隔开

select
t.biz_rule_type23 as bizRuleType23Guid
,t3.name as bizRuleType23Name
,t.guid as orderRefundGuid
,case when(t1.need_deliver_flag='1') then '1' else '2' end as refundHandleFlag
,concat(left(t.prove_logistic_time,4),'年',right(left(t.prove_logistic_time,7),2),'月',right(left(t.prove_logistic_time,10),2),'日') as proveLogisticTime
,case when(t1.need_deliver_flag='1') then t.prove_logistic_img else '系统自动办理完成' end as proveLogisticImgs
,concat(left(t.prove_supply_sign_date,4),'年',right(left(t.prove_supply_sign_date,7),2),'月',right(left(t.prove_supply_sign_date,10),2),'日') as proveSupplySignDate
,case when(t1.need_deliver_flag='1') then t.prove_supply_sign_imgs else '系统自动办理完成' end as proveSupplySignImgs
from
coz_order_refund t
left join
coz_order t1
on t.order_guid=t1.guid
left join 
coz_order_bussiness_rule t3
on t.biz_rule_type23=t3.guid
where 
t.order_guid='{orderGuid}' and t.del_flag='0'
union all
select
t.biz_rule_type21 as bizRuleType23Guid
,t3.name as bizRuleType23Name
,t.guid as orderRefundGuid
,'2' as refundHandleFlag
,concat(left(t.demand_done_time,4),'年',right(left(t.demand_done_time,7),2),'月',right(left(t.demand_done_time,10),2),'日') as proveLogisticTime
,'系统自动办理完成' as proveLogisticImgs
,concat(left(t.supply_done_time,4),'年',right(left(t.supply_done_time,7),2),'月',right(left(t.supply_done_time,10),2),'日') as proveSupplySignDate
,'系统自动办理完成' as proveSupplySignImgs
from
coz_order_cancel t
left join
coz_order t1
on t.order_guid=t1.guid
left join 
coz_order_bussiness_rule t3
on t.biz_rule_type21=t3.guid
where 
t.order_guid='{orderGuid}' and t.del_flag='0'