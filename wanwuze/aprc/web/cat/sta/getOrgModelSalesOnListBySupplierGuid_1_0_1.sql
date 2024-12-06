-- ##Title 运营经理操作系统-品类交易管理-品类供应渠道管理-审批模式-有供应渠道-查看供应渠道详情-查看供应型号详情-型号上架数量-(供方型号)列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 
-- ##Describe coz_category_supplier,coz_category_supplier_am_model,coz_category_supplier_am_model_plate,coz_category_supplier_am_model_price_plate,coz_category_am_modelprice_log
-- ##CallType[QueryData]

-- ##input supplierGuid char[36] NOTNULL;品类供方guid
-- ##input modelName string[50] NULL;型号名称,支持模糊搜索
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output modelName string[50] 型号名称;型号名称

select 
name as modelName
from coz_category_supplier_am_model a 
where 
a.supplier_guid='{supplierGuid}'
and (name like '%{modelName}%' or '{modelName}'='') 
and a.del_flag='0' 
and exists(select 1 from coz_category_supplier_am_model_plate where del_flag='0' and model_guid=a.guid and status='1') 
and exists(select 1 from coz_category_supplier_am_model_price_plate where del_flag='0' and model_guid=a.guid and status='1') 
and exists(select 1 from coz_category_am_modelprice_log where del_flag='0' and biz_guid=a.guid)





