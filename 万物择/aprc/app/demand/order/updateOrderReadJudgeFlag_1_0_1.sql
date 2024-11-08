-- ##Title app-采购-更新订单进入仲裁状态需方阅读标志为已读
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-更新订单进入仲裁状态需方阅读标志为已读
-- ##CallType[ExSql]

-- ##input orderGuid string[200] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_order_judge
set demand_read_flag='1'
,demand_read_time=now()
,update_by='{curUserId}'
,update_time=now()
where order_guid='{orderGuid}' and demand_read_flag='0'