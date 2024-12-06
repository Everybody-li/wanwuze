-- ##Title web-删除需求场景
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除需求场景
-- ##CallType[ExSql]

-- ##input guid char[36] NOTNULL;节点guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_name_tree
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where 
scene_tree_guid='{guid}' or scene_tree_guid in (select guid from coz_category_scene_tree where all_parent_id like '{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\web\scene\allParentId&DBC=w_a&orgPathGuid={guid}&OnlyTagReturn=true]/url}')
;
update coz_category_name_title t
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where scene_tree_guid='{guid}' or scene_tree_guid in (select guid from coz_category_scene_tree where all_parent_id like '{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\web\scene\allParentId&DBC=w_a&orgPathGuid={guid}&OnlyTagReturn=true]/url}')
;
update coz_category_scene_tree
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where 
guid='{guid}' or all_parent_id like '{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\web\scene\allParentId&DBC=w_a&orgPathGuid={guid}&OnlyTagReturn=true]/url}'
;
