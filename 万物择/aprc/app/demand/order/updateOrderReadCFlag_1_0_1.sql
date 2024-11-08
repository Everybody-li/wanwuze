-- ##Title app-采购-更新订单取阅读消标志为已读
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-更新订单取阅读消标志为已读
-- ##CallType[ExSql]

-- ##input orderGuid string[200] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_order
set demand_read_cancel_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{orderGuid}'