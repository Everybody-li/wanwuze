-- ##Title web-供应-更新订单进入仲裁状态需方阅读标志为已读
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-供应-更新订单进入仲裁状态需方阅读标志为已读
-- ##CallType[ExSql]

-- ##input orderGuid string[200] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_order_judge
set supply_read_flag='1'
,supply_read_time=now()
,update_by='{curUserId}'
,update_time=now()
where order_guid='{orderGuid}' and supply_read_flag='0'