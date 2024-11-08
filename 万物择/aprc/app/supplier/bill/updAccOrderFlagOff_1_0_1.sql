-- ##Title app-供应-按单-关闭报价接单
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-按单-关闭报价接单
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input supplierGuid char[36] NOTNULL;供方品类表guid，必填

update coz_category_supplier
set accpet_order_flag='0'
,update_by='{curUserId}'
,update_time=now()
where guid='{supplierGuid}'