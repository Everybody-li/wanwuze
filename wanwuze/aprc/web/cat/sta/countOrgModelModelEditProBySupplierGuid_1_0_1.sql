-- ##Title 运营经理操作系统-品类交易管理-品类供应渠道管理-审批模式-有供应渠道-查看供应渠道详情-查看供应型号详情-型号未上架数量-中间选项卡未编辑型号和已编辑型号数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 运营经理操作系统-品类交易管理-品类供应渠道管理-审批模式-有供应渠道-查看供应渠道详情-查看供应型号详情-型号未上架数量-中间选项卡未编辑型号和已编辑型号数量
-- ##Describe coz_category_supplier,coz_category_supplier_am_model,coz_category_supplier_am_model_plate,coz_category_supplier_am_model_price_plate,coz_category_am_modelprice_log
-- ##CallType[QueryData]

-- ##input supplierGuid char[36] NOTNULL;品类供方guid
-- ##input modelName string[50] NULL;型号名称,支持模糊搜索
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output editModelNum int[>=0] 1;已编辑型号数量
-- ##output noEditModelNum int[>=0] 1;未编辑型号数量

select
editModelNum
,noEditModelNum
from
(
select
(select count(1) from coz_category_supplier_am_model a where a.supplier_guid='{supplierGuid}' and (a.name like '%{modelName}%' or '{modelName}'='')  and a.del_flag='0' and exists(select 1 from coz_category_supplier_am_model_plate where del_flag='0' and model_guid=a.guid and status='1') and (not exists(select 1 from coz_category_supplier_am_model_price_plate where del_flag='0' and model_guid=a.guid and status='1') or not exists(select 1 from coz_category_am_modelprice_log where del_flag='0' and biz_guid=a.guid))) as editModelNum
,(select count(1) from coz_category_supplier_am_model a where a.supplier_guid='{supplierGuid}' and (a.name like '%{modelName}%' or '{modelName}'='')  and a.del_flag='0' and not exists(select 1 from coz_category_supplier_am_model_plate where del_flag='0' and model_guid=a.guid and status='1')) as noEditModelNum
)t1


