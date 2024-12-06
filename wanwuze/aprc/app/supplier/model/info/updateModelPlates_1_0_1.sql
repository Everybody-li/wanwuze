-- ##Title 修改型号的需求范围，多条
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 修改型号的需求范围，多条
-- ##CallType[ExSql]

-- ##input modelPlateGuid char[36] NOTNULL;供方品类型号需求范围表Guid，必填
-- ##input plateFieldValue string[200] NOTNULL;板块字段内容值，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_category_supplier_model_plate
set plate_field_value='{plateFieldValue}'
where guid='{modelPlateGuid}'
;
