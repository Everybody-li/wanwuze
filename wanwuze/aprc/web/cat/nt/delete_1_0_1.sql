-- ##Title web-删除品类字节内容
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除品类字节内容
-- ##CallType[ExSql]

-- ##input guid char[36] NOTNULL;字节内容guid，必填

set @catTreeGuid=(select scene_tree_guid from coz_category_name_tree where guid='{guid}')
;
update coz_category_name_tree
set del_flag='2'
,update_time=now()
where 
guid='{guid}' or all_parent_id like '{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\web\cat\nt\allParentId&DBC=w_a&guid={guid}&OnlyTagReturn=true]/url}'
;
update coz_category_name_title t
set del_flag='2'
,update_time=now()
where not exists(select 1 from coz_category_name_tree where `level`=t.`level` and del_flag='0' and scene_tree_guid=@catTreeGuid) and del_flag='0' and scene_tree_guid=@catTreeGuid