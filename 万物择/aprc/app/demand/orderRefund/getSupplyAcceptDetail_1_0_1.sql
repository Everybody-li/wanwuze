-- ##Title app-采购/供应-查询退货供方验收情况(订单有裁决，供方验收情况)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购/供应-查询退货供方验收情况(订单有裁决，供方验收情况)
-- ##CallType[QueryData]


-- ##input orderGuid char[36] NOTNULL;订单退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output supplyAcceptTime string[10] 0000年-00月-00日;供方验收时间（格式：0000年-00月-00日）
-- ##output supplyAcceptWay int[>=0] 1;供方方验收方式（0：未验收，1：手工验收，2：系统验收）
-- ##output supplyAccept int[>=0] 1;需方验收状态(0：未验收 1：验收通过，2：验收不通过)
-- ##output supplyNotAcceptReason string[100] 供方退货验收不通过事由;供方退货验收不通过事由
-- ##output bizRuleType22Guid char[36] 退货验收规则guid;退货验收规则guid
-- ##output bizRuleType22Name string[100] 退货验收规则名称;退货验收规则名称
select
*
from
(
select 
concat(left(t.supply_accept_time,4),'年',right(left(t.supply_accept_time,7),2),'月',right(left(t.supply_accept_time,10),2),'日') as supplyAcceptTime
,t.supply_accept_way as supplyAcceptWay
,t.supply_accept as supplyAccept
,t.supply_not_accept_reason as supplyNotAcceptReason
,'c9b59ba5-7374-11ec-a478-0242ac120003' as bizRuleType22Guid
,(select name from coz_order_bussiness_rule where guid='c9b59ba5-7374-11ec-a478-0242ac120003') as bizRuleType22Name
,t.supply_accept_prove as supplyAcceptProve
from 
coz_order_refund t
left join
coz_order t1 
on t.order_guid=t1.guid
where 
t.order_guid='{orderGuid}'
union all
select 
concat(left(t.refund_pay_time,4),'年',right(left(t.refund_pay_time,7),2),'月',right(left(t.refund_pay_time,10),2),'日') as supplyAcceptTime
,case when(t.refund_pay_status='2' or t.refund_pay_status='3') then '2' else '0' end as supplyAcceptWay
,case when(t.refund_pay_status='2' or t.refund_pay_status='3') then '1' else '0' end as supplyAccept
,'' as supplyNotAcceptReason
,'c9b59ba5-7374-11ec-a478-0242ac120003' as bizRuleType22Guid
,(select name from coz_order_bussiness_rule where guid='c9b59ba5-7374-11ec-a478-0242ac120003') as bizRuleType22Name
,'' as supplyAcceptProve
from 
coz_order_cancel t
left join
coz_order t1 
on t.order_guid=t1.guid
where 
t.order_guid='{orderGuid}'
)t
order by supplyAcceptTime desc