-- ##Title app-供应-按单-品类按单报价各状态数量统计
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-按单-品类按单报价各状态数量统计
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input supplierGuid char[36] NOTNULL;供方品类表guid，必填

select
*
from
(
select
t.price_status as priceStatus
,count(1) as `count`
from
coz_demand_request_supply t
where 
t.supplier_guid='{supplierGuid}' and (t.price_status='1' or t.price_status='2' or t.price_status='3') and t.del_flag='0' 
group by price_status
)t
order by priceStatus
;