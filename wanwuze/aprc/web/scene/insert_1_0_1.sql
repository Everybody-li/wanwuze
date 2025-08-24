-- ##Title web-新建需求场景
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新建需求场景
-- ##CallType[ExSql]

-- ##input parentGuid string[36] NOTNULL;父级字节内容guid，非必填
-- ##input sdPathGuid string[36] NOTNULL;采购供应路径关联guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input name string[100] NOTNULL;采购/供应场景名称，必填

INSERT INTO coz_category_scene_tree(guid,parent_guid,all_parent_id,sd_path_guid,name,norder,del_flag,create_by,create_time,update_by,update_time,level)
select 
UUID()
,'{parentGuid}'
,ifnull((select CONCAT(ifnull(all_parent_id,''),id,',') from coz_category_scene_tree where guid = '{parentGuid}'),',') as all_parent_id
,'{sdPathGuid}'
,'{name}'
,ifnull((select (max(norder)+1) from coz_category_scene_tree where parent_guid='{parentGuid}' and del_flag='0'),1)
,'0'
,'-1'
,now()
,'-1'
,now() 
,ifnull((select level from coz_category_scene_tree where guid='{parentGuid}'),0)+1
where 
not exists(select 1 from coz_category_scene_tree where name='{name}' and parent_guid='{parentGuid}' and del_flag='0')
limit 1