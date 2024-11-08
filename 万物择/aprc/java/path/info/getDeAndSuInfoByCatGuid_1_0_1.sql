-- ##Title 品类-根据品类guid查询采购路径和供应路径信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 品类-根据品类guid查询采购路径和供应路径信息
-- ##CallType[QueryData]

-- ##input categoryGuid string[36] NOTNULL;品类guid
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t2.guid as sdPathGuid
,t2.name
,t2.demand_path_guid as demandPathGuid
,t2.supply_path_guid as supplyPathGuid
,t4.all_path_name as demandPathName
,t5.all_path_name as supplyPathName
from
coz_category_scene_tree t1
inner join
coz_cattype_sd_path t2
on t1.sd_path_guid=t2.guid
inner join
coz_category_supplydemand t3
on t1.guid=t3.scene_tree_guid
inner join
coz_cattype_demand_path t4
on t2.demand_path_guid=t4.guid
inner join
coz_cattype_supply_path t5
on t2.supply_path_guid=t5.guid
where t3.category_guid='{categoryGuid}' and t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0'
group by t2.guid,t2.name,t2.demand_path_guid,t2.supply_path_guid
order by t1.id desc


