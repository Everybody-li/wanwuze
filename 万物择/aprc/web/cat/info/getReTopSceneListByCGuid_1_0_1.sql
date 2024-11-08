-- ##Title 查询需求场景一级节点列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 查询需求场景一级节点列表
-- ##CallType[QueryData]

-- ##input categoryGuid string[36] NOTNULL;采购供应路径关联guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t1.all_parent_id as allParentId
,t1.parent_guid as parentGuid
,t1.guid
,t1.name
,t1.level
,t1.norder
,t1.remark
,case when exists(select 1 from coz_category_scene_tree where parent_guid=t1.guid and del_flag='0') then '1' else '0' end as hasSon
,left(t1.create_time,19) as createTime
from coz_category_scene_tree t1 
where (exists(select 1 from coz_category_supplydemand where category_guid=(select guid from coz_category_info where guid ='{categoryGuid}') and scene_tree_guid=t1.guid) 
or id in (select replace(SUBSTRING_INDEX(all_parent_id,',', 2),',','') from coz_category_scene_tree where guid in (select scene_tree_guid from coz_category_supplydemand where category_guid=(select guid from coz_category_info where guid ='{categoryGuid}')) and level>2)
or id in (select replace(all_parent_id,',','') from coz_category_scene_tree where guid in (select scene_tree_guid from coz_category_supplydemand where category_guid=(select guid from coz_category_info where guid ='{categoryGuid}')) and level=2)
) and t1.del_flag='0' and t1.level=1