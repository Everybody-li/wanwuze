-- ##Title app-供应-型号-删除型号报价
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-型号-删除型号报价
-- ##CallType[ExSql]

-- ##input modelPriceGuid char[36] NOTNULL;供方型号guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_supplier_model_price_plate t
left join 
coz_category_supplier_model_price t1
on t.model_price_guid=t1.guid
set t.del_flag='2'
,t.update_by='{curUserId}'
,t.update_time=now()
where t.model_price_guid='{modelPriceGuid}' and t1.sale_on_flag='0'
;
update coz_category_supplier_model_price
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{modelPriceGuid}' and sale_on_flag='0'
;
