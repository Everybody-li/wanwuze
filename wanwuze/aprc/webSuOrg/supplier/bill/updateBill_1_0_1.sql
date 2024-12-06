-- ##Title app-供应-按单-已有值修改需求范围内容
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-按单-已有值修改需求范围内容
-- ##CallType[ExSql]

-- ##input supplierBillGuid char[36] NOTNULL;供方品类需求范围表Guid，必填
-- ##input plateFieldValue string[200] NOTNULL;板块字段内容值，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_supplier_bill
set plate_field_value='{plateFieldValue}'
where guid='{supplierBillGuid}'