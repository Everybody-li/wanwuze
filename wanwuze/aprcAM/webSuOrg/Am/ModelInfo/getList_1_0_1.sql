-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-型号列表查询
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询
-- ##Describe 出参”型号产品介绍是否编辑“逻辑：存在t3.status=1，则返回是，否则返回否
-- ##Describe 出参”expireMPMsgShowFlag“逻辑：t2.status=0，则返回是，否则返回否，且弹窗内容：expireMPMsg的值：该品类的型号交易信息有变动，请及时更正，不然影响采购需求接收。
-- ##Describe 出参”expireMRPMsgShowFlag“逻辑：t3.status=0，则返回是，否则返回否，且弹窗内容：expireMRPMsg的值：该品类的型号产品介绍交易信息有变动，请及时更正，不然影响采购需求接收。
-- ##Describe 出参”expireUpdateFlag“逻辑：子表数据型号板块内容是否有有效的值,有的话打勾。
-- ##Describe 排序：id倒序
-- ##Describe 表名：coz_category_supplier_am_model t1,coz_category_supplier_am_model_plate t2,coz_category_supplier_am_model_price_plate t3
-- ##CallType[QueryData]

-- ##input supplierGuid char[36] NOTNULL;供方品类guid
-- ##input modelName string[50] NULL;型号名称，支持模糊搜索
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output modelGuid char[36] 型号guid;型号guid
-- ##output modelName string[50] 型号名称;型号名称
-- ##output hasModelPriceFlag enum[0,1] 1;型号产品介绍是否编辑：0-否，1-是
-- ##output expireMPMsgShowFlag enum[0,1] 1;型号名称的交易信息变更提示窗：0-不弹窗，1-弹窗
-- ##output expireMPMsg string[100] 型号名称的交易信息变更提示窗内容;型号名称的交易信息变更提示窗内容
-- ##output expireMRPMsgShowFlag enum[0,1] 1;型号产品介绍的交易信息变更提示窗：0-不弹窗，1-弹窗（弹窗展示顺序：先弹窗型号名称的，再弹窗型号产品介绍的）
-- ##output expireMRPMsg string[100] 型号产品介绍的交易信息变更提示窗内容;型号产品介绍的交易信息变更提示窗内容
-- ##output expireUpdateFlag enum[0,1] 1;型号是否编辑：0-不编辑，1-编辑

select
t.*
,case when (t.expireMPMsgShowFlag='1') then '该品类的型号交易信息有变动，请及时更正，不然影响采购需求接收。' else '' end as expireMPMsg
,case when (t.expireMRPMsgShowFlag='1') then '该品类的型号产品介绍交易信息有变动，请及时更正，不然影响采购需求接收。' else '' end as expireMRPMsg
from
( 
select
t1.guid as modelGuid
,t1.name as modelName
,case when exists(select 1 from coz_category_supplier_am_model_price_plate where status='1' and model_guid=t1.guid and del_flag='0') then '1' else '0' end as hasModelPriceFlag
,case when exists(select 1 from coz_category_supplier_am_model_plate where status='0' and model_guid=t1.guid and del_flag='0') then '1' else '0' end as expireMPMsgShowFlag
,case when exists(select 1 from coz_category_supplier_am_model_price_plate where status='0' and model_guid=t1.guid and del_flag='0') then '1' else '0' end as expireMRPMsgShowFlag
,t1.id
,case when (exists(select 1 from coz_category_supplier_am_model_plate where status='1' and model_guid=t1.guid and del_flag='0')) then '1' else '0' end as expireUpdateFlag
from
coz_category_supplier_am_model t1
where t1.supplier_guid='{supplierGuid}' and t1.del_flag='0' and (t1.name like'%{modelName}%' or '{modelName}'='')
)t
order by t.id desc