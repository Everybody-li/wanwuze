-- ##Title app-供应-型号-删除需求范围-按型号模式
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-型号-删除需求范围-按型号模式
-- ##CallType[ExSql]

-- ##input supplierGuid char[36] NOTNULL;供方品类表guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_category_supplier_model_price_plate
set del_flag='2'
where model_price_guid in (select guid from coz_category_supplier_model_price where model_guid in (select guid from coz_category_supplier_model where supplier_guid='{supplierGuid}'))
;
update coz_category_supplier_model_plate
set del_flag='2'
where model_guid in (select guid from coz_category_supplier_model where supplier_guid='{supplierGuid}')
;
update coz_category_supplier_model
set del_flag='2'
,update_time=now()
where supplier_guid='{supplierGuid}'
;
update coz_category_supplier_model_price
set del_flag='2'
,update_time=now()
where model_guid in (select guid from coz_category_supplier_model where supplier_guid='{supplierGuid}')


