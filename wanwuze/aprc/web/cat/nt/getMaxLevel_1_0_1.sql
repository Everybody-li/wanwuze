-- ##Title web-查询品类字节标题最大层级_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类字节标题最大层级_1_0_1
-- ##CallType[QueryData]

-- ##input sceneGuid char[36] NOTNULL;末级场景guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output level int[>=0] 1;字节内容层级


select ifnull((select max(level) as level from coz_category_name_title t where t.scene_tree_guid='{sceneGuid}' and t.del_flag='0'),'0') as level
