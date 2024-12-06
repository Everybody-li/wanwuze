-- ##Title 运营经理操作系统-品类交易管理-品类供应渠道管理-审批模式-有供应渠道-查看品类型号详情-型号未上架数量-中间选项卡未编辑型号和已编辑型号数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 运营经理操作系统-品类交易管理-品类供应渠道管理-审批模式-有供应渠道-查看品类型号详情-型号未上架数量-中间选项卡未编辑型号和已编辑型号数量
-- ##Describe coz_category_supplier,coz_category_supplier_am_model,coz_category_supplier_am_model_plate,coz_category_supplier_am_model_price_plate,coz_category_am_modelprice_log
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input orgName string[50] NULL;供应渠道名称,支持模糊搜索
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output editModelNum int[>=0] 1;已编辑型号数量
-- ##output noEditModelNum int[>=0] 1;未编辑型号数量

select
sum(editModelNum) as editModelNum
,sum(noEditModelNum) as noEditModelNum
from
(
select
(select count(1) from coz_category_supplier_am_model a where a.supplier_guid=t2.guid and a.del_flag='0' and exists(select 1 from coz_category_supplier_am_model_plate where del_flag='0' and model_guid=a.guid and status='1') and (not exists(select 1 from coz_category_supplier_am_model_price_plate where del_flag='0' and model_guid=a.guid and status='1') or not exists(select 1 from coz_category_am_modelprice_log where del_flag='0' and biz_guid=a.guid))) as editModelNum
,(select count(1) from coz_category_supplier_am_model a where a.supplier_guid=t2.guid and a.del_flag='0' and not exists(select 1 from coz_category_supplier_am_model_plate where del_flag='0' and model_guid=a.guid and status='1') ) as noEditModelNum
from
coz_org_info t1
inner join
coz_category_supplier t2
on t1.user_id=t2.user_id
where t1.del_flag='0' and t2.del_flag='0' and t2.category_guid='{categoryGuid}' and (t1.name like '%{orgName}%' or '{orgName}'='')
)t1


