-- ##Title app-供应-型号-判断型号是否可以上架
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-型号-判断型号是否可以上架
-- ##CallType[QueryData]

-- ##input modelPriceGuid char[36] NOTNULL;供方型号guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output canSales int[>=0] 1;（0：不可以，1：可以）

select
case when exists(select 1 from coz_category_supplier_model_price_plate t left join coz_model_plate_field_formal t2 on t.plate_field_formal_guid=t2.guid left join coz_model_fixed_data t3 on t2.name=t3.code where t3.code in ('f00051','f00062')  and t.model_price_guid='{modelPriceGuid}') then '1' else '0'  end as canSales