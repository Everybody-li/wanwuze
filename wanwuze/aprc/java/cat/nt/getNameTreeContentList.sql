-- ##Title 根据末级场景获取品类字节内容列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据末级场景获取品类字节内容列表
-- ##CallType[QueryData]

-- ##input sceneGuid char[36] NOTNULL;末级场景guid，必填

-- ##output guid char[36] 字节内容guid;字节内容guid
-- ##output name string[20] 字节内容名称;字节内容名称
-- ##output parentGuid char[36] 字节内容父guid;字节内容父guid
-- ##output level int[>=0] 1;字节内容层级
-- ##output isEndNode int[>=0] 0;是否叶子节点（是否末级节点）


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