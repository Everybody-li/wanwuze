-- ##Title web-查询品类名称关联的采购路径和供应路径
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类名称关联的采购路径和供应路径
-- ##CallType[QueryData]

-- ##input categoryGuid string[36] NOTNULL;品类guid

-- ##output guid char[36] 品类guid;
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output img string[50] 品类图片地址;品类图片地址
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output delBtnFlag int[>=0] 1;品类删除按钮高亮标志（0：置灰，1：高亮）

select
t4.guid as demandPathGuid
,t4.all_path_name as demandPathName
,t5.guid as supplyPathGuid
,t5.all_path_name as supplyPathName
,t3.guid as sdPathGuid
,case when (t2.all_parent_id=',' or t2.all_parent_id is null) then t2.name else concat((select replace(group_concat(name),',','>') from coz_category_scene_tree where sd_path_guid=t3.guid and del_flag='0' and t2.all_parent_id like concat('%,',id,'%') order by id),'>',t2.name) end as scenePathName
,t1.id
from
coz_category_supplydemand t1
left join
coz_category_scene_tree t2
on t1.scene_tree_guid=t2.guid
left join
coz_cattype_sd_path t3
on t2.sd_path_guid=t3.guid
left join
coz_cattype_demand_path t4
on t3.demand_path_guid=t4.guid
left join
coz_cattype_supply_path t5
on t3.supply_path_guid=t5.guid
where t1.category_guid='{categoryGuid}' and t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and t4.del_flag='0' and t5.del_flag='0' 
