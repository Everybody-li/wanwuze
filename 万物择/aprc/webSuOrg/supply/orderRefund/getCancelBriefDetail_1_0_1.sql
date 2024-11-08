-- ##Title app-采购/供应-查询退货订单成果详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购/供应-查询退货订单成果详情
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;采购供应路径关联guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
case when exists(select 1 from coz_order_cancel where order_guid=t.guid and del_flag='0') then '1' else '0' end as orderCancelFlag
,(select cancel_object from coz_order_cancel where order_guid=t.guid and del_flag='0' order by id desc limit 1) as orderCancelObject
,(select left(create_time,10) from coz_order_cancel where order_guid=t.guid and del_flag='0' order by id desc limit 1) as orderCancelTime
,CONCAT('{ChildRows_aprc\\webSuOrg\\supply\\orderRefund\\getOutcomeDetails_1_0_1:orderGuid=''',t.guid,'''}') as outcome
from  
coz_order t
where 
t.guid='{orderGuid}' and t.del_flag='0'