-- ##Title web-交易条件管理-查询交易组织跟踪管理-供应机构数量详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-交易条件管理-查询交易组织跟踪管理-供应机构数量详情
-- ##Describe coz_category_supplydemand t2,coz_category_scene_tree t3,coz_cattype_sd_path t4, coz_cattype_supply_path_lgcode t5,coz_lgcode_fixed_data t6.coz_org_info t7
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input orgName string[50] NULL;机构名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output registerTime string[16] 账号创建日期;账号创建日期
-- ##output orgName string[50] 机构名称;机构名称
-- ##output orgGuid char[36] ;供应机构guid
-- ##output orgUserId char[36] ;供应机构用户id
-- ##output orgID string[18] 机构账号ID;机构账号ID
-- ##output phonenumber string[50] 登录手机号;登录手机号
-- ##output supplySystem string[50] 供应管理系统;供应管理系统
-- ##output saleOnModelNum int[>=0] 1;品类的型号上架数量
-- ##output saleOffModelNum int[>=0] 1;型号未上架数量
-- ##output supplierGuid string[50] 供方品类表guid;供方品类表guid

select
registerTime
,orgName
,orgGuid
,orgUserId
,orgID
,phonenumber
,supplySystem
,saleOnModelNum
,supplierGuid
,modelNum-saleOnModelNum as saleOffModelNum
from
(
select
left(t1.create_time,16) as registerTime
,t1.name as orgName
,t1.guid as orgGuid
,t1.user_id as orgUserId
,t1.org_ID as orgID
,t2.guid as supplierGuid
,concat('(+86)',t1.phonenumber) as phonenumber
,(select a.login_sysname from coz_lgcode_fixed_data a inner join coz_org_info_lgcode b on b.lgcode_guid=a.guid where b.user_id=t1.user_id and a.del_flag='0' and b.del_flag='0' order by b.id desc limit 1) as supplySystem
,(select count(1) from coz_category_supplier_am_model a where a.supplier_guid=t2.guid and a.del_flag='0') as modelNum
,(select count(1) from coz_category_supplier_am_model a where a.supplier_guid=t2.guid and a.del_flag='0' and exists(select 1 from coz_category_supplier_am_model_plate where del_flag='0' and model_guid=a.guid and status='1') and exists(select 1 from coz_category_supplier_am_model_price_plate where del_flag='0' and model_guid=a.guid and status='1') and exists(select 1 from coz_category_am_modelprice_log where del_flag='0' and biz_guid=a.guid)) as saleOnModelNum
,t1.id
from
coz_org_info t1
inner join
coz_category_supplier t2
on t1.user_id=t2.user_id
where t1.del_flag='0' and t2.del_flag='0' and t2.category_guid='{categoryGuid}' and (t1.name like '%{orgName}%' or '{orgName}'='')
)t1
order by t1.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};


