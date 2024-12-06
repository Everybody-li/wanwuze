-- ##Title app-供应-型号-新增型号报价-按型号模式
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-型号-新增型号报价-按型号模式
-- ##CallType[ExSql]

-- ##input modelPriceGuid char[36] NOTNULL;供方品类型号价格表guid（app自己生成uuid），必填
-- ##input modelGuid char[36] NOTNULL;型号guid，必填
-- ##input bankUserName string[40] NOTNULL;开户账户名称，必填
-- ##input bankName string[40] NOTNULL;开户银行，必填
-- ##input bankUserNo string[20] NOTNULL;开户银行账号，必填
-- ##input bankAddr string[100] NOTNULL;开户银行地址，必填
-- ##input supplyCompanyName string[50] NOTNULL;供应主体，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_category_supplier_model_price(guid,model_guid,bank_user_name,bank_name,bank_user_no,bank_addr,supply_company_name,del_flag,create_by,create_time,update_by,update_time)
select
'{modelPriceGuid}'
,'{modelGuid}'
,'{bankUserName}'
,'{bankName}'
,'{bankUserNo}'
,'{bankAddr}'
,'{supplyCompanyName}'
,'0'
,'1'
,now()
,'1'
,now()
from
coz_category_supplier_model
where guid='{modelGuid}' and not exists(select 1 from coz_category_supplier_model_price where guid='{modelPriceGuid}')
;
delete from coz_biz_city_code_temp where biz_guid='{modelPriceGuid}'
;