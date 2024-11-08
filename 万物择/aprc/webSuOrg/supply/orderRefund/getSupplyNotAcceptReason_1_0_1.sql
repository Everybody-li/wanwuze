-- ##Title web-供应-查询供方验收不通过事由
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-供应-查询供方验收不通过事由
-- ##CallType[QueryData]


-- ##input orderGuid char[36] NOTNULL;订单退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
*
from
(
select 
concat(left(t.supply_accept_time,4),'年',right(left(t.supply_accept_time,7),2),'月',right(left(t.supply_accept_time,10),2),'日') as supplyAcceptTime
,t.supply_accept_prove as supplyAcceptProve
,t.supply_not_accept_reason as supplyNotAcceptReason
,(select guid from coz_order_bussiness_rule where type = 22) as applyRuleGuid
,(select name from coz_order_bussiness_rule where type = 22) as applyRuleName
from 
coz_order_refund t
left join
coz_order t1 
on t.order_guid=t1.guid
where 
t.order_guid='{orderGuid}'
)t
order by supplyAcceptTime desc