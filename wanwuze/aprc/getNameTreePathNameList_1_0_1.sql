-- ##Title 品类-根据末级字节内容guid获取品类字节内容信息列表_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 品类-根据末级字节内容guid获取品类字节内容信息列表_1_0_1
-- ##CallType[QueryData]

-- ##input nameTreeGuid string[4000] NOTNULL;末级字节内容Guid(支持多个，格式：''guid1','guid2'.....'guidN'')，必填



select
t.guid
,t.name
,t.parent_guid as parentGuid
,t.level
,case when not exists(select 1 from coz_category_name_tree where parent_guid=t.guid and del_flag='0') then '1' else 0 end as isEndNode
from
coz_category_name_tree t
where 
t.scene_tree_guid='{sceneGuid}' and t.del_flag='0'
order by t.norder