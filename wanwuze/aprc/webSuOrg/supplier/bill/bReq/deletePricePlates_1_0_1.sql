-- ##Title app-供应-按单-删除按单报价
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-按单-删除按单报价
-- ##CallType[ExSql]

-- ##input requestSupplyGuid char[36] NOTNULL;供方需求表guid，必填
-- ##input requestPriceGuid char[36] NOTNULL;供方报价表guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_demand_request_price_plate t
left join 
coz_demand_request_price t1
on t.request_price_guid=t1.guid
left join
coz_demand_request_supply t2
on t1.request_supply_guid=t2.guid
set t.del_flag='2'
,t.update_by='{curUserId}'
,t.update_time=now()
where t1.guid='{requestPriceGuid}' and t2.select_flag<>'1'
;
update coz_demand_request_price t
left join
coz_demand_request_supply t1
on t.request_supply_guid=t1.guid
set t.del_flag='2'
,t.update_by='{curUserId}'
,t.update_time=now()
where 
t.guid='{requestPriceGuid}' and  t1.select_flag<>'1'
;
update coz_demand_request_supply
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{requestSupplyGuid}' and select_flag<>'1'
;