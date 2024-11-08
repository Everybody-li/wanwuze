-- ##Title web-查询需求场景下是否有品类生成器
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询需求场景下是否有品类生成器
-- ##CallType[QueryData]

-- ##input sceneGuid char[36] NOTNULL;需求场景guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
case when (exists(select 1 from coz_category_supplydemand t left join coz_category_info t1 on t.category_guid=t1.guid where t.scene_tree_guid='{sceneGuid}'and t.del_flag='0' and t1.del_flag='0')) then 1 else 0 end as num
