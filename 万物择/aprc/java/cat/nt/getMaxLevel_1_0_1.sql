-- ##Title 查询品类字节标题最大层级
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 查询品类字节标题最大层级
-- ##CallType[QueryData]

-- ##input secenGuid char[36] NOTNULL;末级场景guid，必填

-- ##output level int[>=0] 1;字节内容层级


select
max(level) as level
from
coz_category_name_title t
where 
t.scene_tree_guid='{secenGuid}' and t.del_flag='0'
