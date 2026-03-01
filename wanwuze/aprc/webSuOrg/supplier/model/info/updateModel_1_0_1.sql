-- ##Title app-供应-型号-修改需求范围内容
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-型号-修改需求范围内容
-- ##CallType[ExSql]

-- ##input supplierGuid char[36] NOTNULL;供方品类表guid（app自己生成uuid），必填
-- ##input modelName string[200] NOTNULL;型号名称，必填
-- ##input modelGuid char[36] NOTNULL;型号guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_supplier_model
set name='{modelName}'
,update_by='{curUserId}'
,update_time=now()
where guid='{modelGuid}'
;
