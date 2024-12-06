-- ##Title web后台-审批报价配置管理-xx供应路径-供应审批报价管理-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-08-04
-- ##Describe 查询 品类类型模式为审批模式的供应路径数据
-- ##Describe coz_org_info t1,coz_category_supplier t2 coz_category_info t3,coz_category_scene_tree t4,coz_cattype_sd_path t5,coz_cattype_supply_path_lgcode t6,coz_lgcode_fixed_data t7
-- ##CallType[QueryData]

-- ##input orgUserGuid char[36] NOTNULL;机构用户guid
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input categoryName string[500] NULL;品类名称
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId char[36] NOTNULL;当前登录用户id


-- ##output cattypeGuid char[36] 品类类型guid;
-- ##output categoryGuid char[36] 品类guid;
-- ##output categoryName string[500] 品类名称;
-- ##output supplyPathName string[100] 供应路径名称(格式：资金资源需求>管理>债权资金申请);
-- ##output supplierGuid char[36] 供方品类guid;供方品类guid

select
t3.cattype_guid as cattypeGuid
,t3.guid as categoryGuid
,t3.name as categoryName
,t7.all_path_name as supplyPathName
,t2.guid as supplierGuid
from
coz_org_info t1
inner join
coz_category_supplier t2
on t2.user_id=t1.user_id
inner join
coz_category_info t3
on t2.category_guid=t3.guid
inner join
coz_category_supplydemand t4
on t3.guid=t4.category_guid
inner join
coz_category_scene_tree t5
on t4.scene_tree_guid=t5.guid
inner join
coz_cattype_sd_path t6
on t5.sd_path_guid=t6.guid
inner join
coz_cattype_supply_path t7
on t6.supply_path_guid=t7.guid
where t5.sd_path_guid='{sdPathGuid}' and t1.user_id='{orgUserGuid}' and t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and t4.del_flag='0' and t5.del_flag='0' and t6.del_flag='0' and t7.del_flag='0' and (t3.name like '%{categoryName}%' or '{categoryName}'='')
order by t1.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};