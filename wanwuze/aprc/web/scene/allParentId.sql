-- ##Title 根据末级场景获取末级场景祖辈列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据末级场景获取品类字节内容列表
-- ##CallType[QueryData]

-- ##input orgPathGuid char[36] NOTNULL;节点guid，必填


select concat('%,',id,',%') from coz_category_scene_tree where guid='{orgPathGuid}'