-- ##Title 运营经理操作系统-品类交易管理-品类供应渠道管理-审批模式-有供应渠道-查看品类型号详情-型号上架数量-(供方型号)列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 1.型号板块内容有有效数据
-- ##Describe 2.型号产品介绍板块内容有有效数据
-- ##Describe 3.型号在审批报价配置管理中发布过
-- ##Describe 以上1,2,3都满足,则代表型号已上架,此接口查询已上架的
-- ##Describe coz_category_supplydemand t2,coz_category_scene_tree t3,coz_cattype_sd_path t4, coz_cattype_supply_path_lgcode t5,coz_lgcode_fixed_data t6.coz_org_info t7
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input orgName string[50] NULL;供应渠道名称,支持模糊搜索
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output registerTime string[16] 账号创建日期;账号创建日期
-- ##output orgName string[50] 机构名称;机构名称
-- ##output orgGuid char[36] ;供应机构guid
-- ##output orgUserId char[36] ;供应机构用户id
-- ##output orgID string[18] 机构账号ID;机构账号ID
-- ##output phonenumber string[50] 登录手机号;登录手机号
-- ##output supplySystem string[50] 供应管理系统;供应管理系统
-- ##output modelName string[50] 型号名称;型号名称


select
left(t1.create_time,16) as registerTime
,t1.name as orgName
,t1.guid as orgGuid
,t1.user_id as orgUserId
,t1.org_ID as orgID
,concat('(+86)',t1.phonenumber) as phonenumber
,(select a.login_sysname from coz_lgcode_fixed_data a inner join coz_org_info_lgcode b on b.lgcode_guid=a.guid where b.user_id=t1.user_id and a.del_flag='0' and b.del_flag='0' order by b.id desc limit 1) as supplySystem
,t3.name as modelName
from
coz_org_info t1
inner join
coz_category_supplier t2
on t1.user_id=t2.user_id
inner join 
coz_category_supplier_am_model t3
on t3.supplier_guid=t2.guid
where t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' 
and t2.category_guid='{categoryGuid}' 
and (t1.name like '%{orgName}%' or '{orgName}'='')
and exists(select 1 from coz_category_supplier_am_model_plate where del_flag='0' and model_guid=t3.guid and status='1') 
and exists(select 1 from coz_category_supplier_am_model_price_plate where del_flag='0' and model_guid=t3.guid and status='1') 
and exists(select 1 from coz_category_am_modelprice_log where del_flag='0' and biz_guid=t3.guid)
order by t1.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};


