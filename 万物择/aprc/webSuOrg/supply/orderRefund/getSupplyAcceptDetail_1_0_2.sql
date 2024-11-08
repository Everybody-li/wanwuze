-- ##Title app-采购/供应-查询退货供方验收情况(订单有裁决，供方验收情况)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购/供应-查询退货供方验收情况(订单有裁决，供方验收情况)
-- ##CallType[QueryData]


-- ##input orderGuid char[36] NOTNULL;订单退货guid，必填
-- ##input categoryName string[500] NOTNULL;品类名称，必填
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
,case when (t.supply_accept_way='0') then '未验收' when (t.supply_accept_way='1') then '手工验收' when (t.supply_accept_way='2') then '系统验收' else '' end as supplyAcceptWay
,t.supply_accept as supplyAccept
,case when (t.supply_accept='0') then '未验收' when (t.supply_accept='1') then '验收通过' when (t.supply_accept='2') then '验收不通过' else '' end as supplyAcceptStr
,t.supply_not_accept_reason as supplyNotAcceptReason
,concat('【{categoryName}】<br>采购编号：',t1.order_no,'<br>本订单供方验收不通过。若有异议，请通过【菜单-反馈】页面的使用【退货退款异常反馈】。') as supplyNotAcceptPromtMsg
,(select guid from coz_order_bussiness_rule where type = 22) as applyRuleGuid
,(select name from coz_order_bussiness_rule where type = 22) as applyRuleName
,case when(t1.need_deliver_flag='1') then '1' else '2' end as refundHandleFlag
from 
coz_order_refund t
left join
coz_order t1 
on t.order_guid=t1.guid
where 
t.order_guid='{orderGuid}'
union all
select 
concat(left(t.supply_done_time,4),'年',right(left(t.supply_done_time,7),2),'月',right(left(t.supply_done_time,10),2),'日') as supplyAcceptTime
,case when (t.supply_done_way='0') then '未验收' when (t.supply_done_way='1') then '手工验收' when (t.supply_done_way='2') then '系统验收' else '' end as supplyAcceptWay
,'1' as supplyAccept
,'验收通过' as supplyAcceptStr
,'' as supplyNotAcceptReason
,concat('【{categoryName}】<br>采购编号：',t1.order_no,'<br>本订单供方验收不通过。若有异议，请通过【菜单-反馈】页面的使用【退货退款异常反馈】。') as supplyNotAcceptPromtMsg
,(select guid from coz_order_bussiness_rule where type = 22) as applyRuleGuid
,(select name from coz_order_bussiness_rule where type = 22) as applyRuleName
,'2' refundHandleFlag
from 
coz_order_cancel t
left join
coz_order t1 
on t.order_guid=t1.guid
where 
t.order_guid='{orderGuid}'
)t
order by supplyAcceptTime desc