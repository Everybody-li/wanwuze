-- ##Title app-供应-型号-查询型号名称是否重复
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-型号-查询型号名称是否重复
-- ##CallType[ExSql]

-- ##input supplierGuid char[36] NOTNULL;供方品类表guid（app自己生成uuid），必填
-- ##input modelGuid char[36] NOTNULL;供方品类表guid（app自己生成uuid），必填
-- ##input modelName string[50] NOTNULL;型号名称，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select case when(exists(select 1 from coz_category_supplier_model where name='{modelName}' and supplier_guid='{supplierGuid}' and guid<>'{modelGuid}' and del_flag='0')) then '1' else '0' end as existsFlag
;
