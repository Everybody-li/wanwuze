-- ##Title 需求-查询供方报价情况
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 需求-查询供方报价情况
-- ##CallType[QueryData]

-- ##input requestGuid char[36] NOTNULL;需求guid，必填
-- ##input requestSupplyGuid char[36] NOTNULL;需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t1.request_guid as requestGuid
,t1.price_status as priceStatus
from
coz_demand_request_supply t1
where 
t1.guid='{requestSupplyGuid}'  and t1.del_flag='0' and t1.request_guid ='{requestGuid}'
order by t1.create_time desc