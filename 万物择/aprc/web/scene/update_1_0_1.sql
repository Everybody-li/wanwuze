-- ##Title web-编辑需求场景
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-编辑需求场景
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input guid char[36] NOTNULL;节点guid，必填
-- ##input name string[20] NOTNULL;需求场景名称，必填

set @parent_guid=(select parent_guid from coz_category_scene_tree where guid='{guid}')
;
set @flag1=(select case when exists(select 1 from coz_category_scene_tree where parent_guid=@parent_guid and del_flag='0' and name='{name}' and guid<>'{guid}') then '0' else '1' end)
;
update coz_category_scene_tree
set name='{name}'
,update_by='{curUserId}'
,update_time=now()
where guid='{guid}' and @flag1='1'