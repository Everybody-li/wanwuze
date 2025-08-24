-- ##Title 需求-查询子级需求及需求供方guid
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 需求-查询子级需求及需求供方guid
-- ##CallType[QueryData]

-- ##input requestGuid char[36] NOTNULL;需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output requestGuid char[36] 子级需求guid;子级需求guid
-- ##output requestSupplyGuid char[36] 子级需求供方guid;子级需求供方guid

select
t2.guid as requestPriceGuid
,t1.guid as requestSupplyGuid
,t.guid as requestGuid
,t2.supply_price as supplyPrice
,t.category_guid as categoryGuid
from
coz_demand_request t
left join
coz_demand_request_supply t1
on t1.request_guid=t.guid
left join
coz_demand_request_price t2
on t2.request_supply_guid=t1.guid
where 
t.parent_guid='{requestGuid}' and t.del_flag='0'
order by t.id desc
