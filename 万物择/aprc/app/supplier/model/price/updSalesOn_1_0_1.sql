-- ##Title app-供应-型号-型号上架
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-型号-型号上架
-- ##CallType[ExSql]

-- ##input modelPriceGuid char[36] NOTNULL;供方型号guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_supplier_model_price
set sale_on_flag='1'
,update_by='{curUserId}'
,update_time=now()
where guid='{modelPriceGuid}' and exists(select 1 from coz_category_supplier_model_price_plate where plate_field_code in ('f00051','f00062')  and model_price_guid='{modelPriceGuid}')
;
