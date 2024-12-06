-- ##Title 根据末级场景获取末级场景祖辈列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据末级场景获取品类字节内容列表
-- ##CallType[QueryData]

-- ##input nameTreeGuid char[36] NOTNULL;字节内容guid，必填


select concat('%,',id,',%') from coz_category_name_tree where guid='{nameTreeGuid}'