-- ##Title app-采购-修改供方报价内容阅读标志为已阅读
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-修改供方报价内容阅读标志为已阅读
-- ##CallType[ExSql]

-- ##input requestSupplyGuid char[36] NOTNULL;需求guid，必填
-- ##input curUserId string[36] NOTNULL;需方用户id，必填

update coz_demand_request_supply
set de_read_flag='2'
,de_read_time=now()
,update_by='{curUserId}'
,update_time=now()
where guid='{requestSupplyGuid}'
;