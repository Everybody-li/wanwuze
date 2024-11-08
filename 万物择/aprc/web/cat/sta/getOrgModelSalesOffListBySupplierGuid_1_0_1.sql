-- ##Title 运营经理操作系统-品类交易管理-品类供应渠道管理-审批模式-有供应渠道-查看供应渠道详情-查看供应型号详情-型号未上架数量-(供方型号)列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 1.型号板块内容有有效数据
-- ##Describe 2.型号产品介绍板块内容有有效数据
-- ##Describe 3.型号在审批报价配置管理中发布过
-- ##Describe 以上1,2,3都满足,则代表型号已上架,此接口查询未上架的
-- ##Describe coz_category_supplydemand t2,coz_category_scene_tree t3,coz_cattype_sd_path t4, coz_cattype_supply_path_lgcode t5,coz_lgcode_fixed_data t6.coz_org_info t7
-- ##CallType[QueryData]

-- ##input supplierGuid char[36] NOTNULL;品类供方guid
-- ##input modelName string[50] NULL;型号名称,支持模糊搜索
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input editModelFlag enum[0,1] NULL;是否编辑型号（0=未编辑，1=已编辑）
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


-- ##output modelName string[50] 型号名称;型号名称
-- ##output editModelFlag enum[0,1] 1;是否编辑型号（0=未编辑，1=已编辑）
-- ##output editModelPriceFlag enum[0,1] 1;是否编辑型号产品介绍（0=未编辑，1=已编辑）
-- ##output publishPriceFlag enum[0,1] 1;审批报价是否发布（0=未发布，1=已发布）

select
*
from
(
select
t1.name as modelName
,t1.id
,case when (exists(select 1 from coz_category_supplier_am_model_plate where del_flag='0' and model_guid=t1.guid and status='1')) then '1' else '0' end as editModelFlag
,case when (exists(select 1 from coz_category_supplier_am_model_price_plate where del_flag='0' and model_guid=t1.guid and status='1')) then '1' else '0' end as editModelPriceFlag
,case when (exists(select 1 from coz_category_am_modelprice_log where del_flag='0' and biz_guid=t1.guid)) then '1' else '0' end as publishPriceFlag
from
coz_category_supplier_am_model t1
where t1.del_flag='0'
and t1.supplier_guid='{supplierGuid}' 
and (t1.name like '%{modelName}%' or '{modelName}'='')
)t1
where (editModelFlag='0' or editModelPriceFlag='0' or publishPriceFlag='0') and (editModelFlag='{editModelFlag}')
order by t1.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};


