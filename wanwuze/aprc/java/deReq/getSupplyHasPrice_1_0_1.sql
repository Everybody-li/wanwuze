-- ##Title 需求-查询已报价的供方
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 需求-查询已报价的供方
-- ##CallType[QueryData]

-- ##input requestGuid char[36] NOTNULL;需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output supplier_guid char[36] 供方用户id;供方用户id
-- ##output requestGuid char[36] 需求guid;需求guid
-- ##output requestSupplyGuid char[36] 需求供方guid;需求供方guid
-- ##output requestPriceGuid char[36] 需求供方价格guid;需求供方价格guid

select
t1.supplier_guid as supplierGuid
,t2.guid as requestGuid
,t1.guid as requestSupplyGuid
,t.guid as requestPriceGuid
from
coz_demand_request_price t
left join
coz_demand_request_supply t1
on t.request_supply_guid=t1.guid
left join
coz_demand_request t2
on t1.request_guid=t2.guid
where 
t2.guid='{requestGuid}' and t.del_flag='0' and t1.del_flag='0' and t2.del_flag='0' and t1.price_status=3 and t2.done_flag = 0
order by t.create_time desc