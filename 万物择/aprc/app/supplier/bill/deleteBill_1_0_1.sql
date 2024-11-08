-- ##Title app-供应-按单-删除需求范围
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-按单-删除需求范围
-- ##CallType[ExSql]

-- ##input supplierGuid char[36] NOTNULL;供方品类表guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_category_supplier_bill
set del_flag='2'
where supplier_guid='{supplierGuid}'
;