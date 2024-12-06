-- ##Title web后台-审批报价配置管理-xx供应路径-查询下方机构信息列表数据
-- ##Author 卢文彪
-- ##CreateTime 2023-08-04
-- ##Describe 查询 品类类型模式为审批模式的供应路径数据
-- ##Describe coz_org_info t1,coz_category_supplier t2 coz_category_info t3,coz_category_scene_tree t4,coz_cattype_sd_path t5,coz_cattype_supply_path_lgcode t6,coz_lgcode_fixed_data t7
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input orgName string[50] NULL;机构名称或者登录手机号
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output orgUserGuid char[36] 机构用户guid;
-- ##output orgName string[50] 机构名称;机构名称
-- ##output phonenumber string[50] 登录手机号;登录手机号
-- ##output supplySystem string[50] 供应管理系统;供应管理系统

select
*
from
(
select
t1.user_id as orgUserGuid
,t1.name as orgName
,concat('(+86)',t1.phonenumber) as phonenumber
,(select a.login_sysname from coz_lgcode_fixed_data a where a.guid=t6.lgcode_guid and a.del_flag='0') as supplySystem
,t1.id
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
where t5.sd_path_guid='{sdPathGuid}' and t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and t4.del_flag='0' and t5.del_flag='0' and t6.del_flag='0' and (t1.name like '%{orgName}%' or t1.phonenumber like '%{orgName}%' or '{orgName}'='')
)t1
group by t1.orgUserGuid,t1.orgName,t1.phonenumber,t1.supplySystem
order by t1.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};