-- ##Title 根据品类名称查询品类重复及关联情况
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据品类名称查询品类重复及关联情况
-- ##CallType[QueryData]

-- ##output guid char[36] 关联的末级场景guid;关联的末级场景guid（不一定有值，固化的品类一开始没有关联场景，可能有值，多个，一个品类可关联多个场景）

select
t.scene_tree_guid as guid
,t.category_guid as categoryGuid
from
coz_category_supplydemand t
left join
coz_category_info t1
on t.category_guid=t1.guid
where 
t1.name in({categoryName}) and t.del_flag=0 and t1.cattype_guid='{cattypeGuid}'
