-- ##Title app-供应-型号-新增需求范围内容
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-型号-新增需求范围内容
-- ##CallType[ExSql]

-- ##input supplierGuid char[36] NOTNULL;供方品类表guid（app自己生成uuid），必填
-- ##input modelName string[200] NOTNULL;型号名称，必填
-- ##input modelGuid char[36] NOTNULL;型号guid，必填

insert into coz_category_supplier_model(guid,supplier_guid,name,del_flag,create_by,create_time,update_by,update_time)
select
'{modelGuid}'
,'{supplierGuid}'
,'{modelName}'
,'0'
,'1'
,now()
,'1'
,now()
from
coz_category_supplier t
where t.guid='{supplierGuid}' and not exists(select 1 from coz_category_supplier_model where guid='{modelGuid}')
and not exists(select 1 from coz_category_supplier_model where name='{modelName}' and supplier_guid='{supplierGuid}' and del_flag='0')
;
delete from coz_biz_city_code_temp where biz_guid='{modelGuId}'
;