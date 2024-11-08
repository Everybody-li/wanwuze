-- ##Title 品类-查询字节内容信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 品类-查询字节内容信息
-- ##CallType[QueryData]

-- ##input nameTreeGuid char[36] NOTNULL;字节内容guid，必填

-- ##output secenGuid char[36] 末级场景guid;末级场景guid
-- ##output allParentId string[200] 所有父亲及祖父节点id;所有父亲及祖父节点id
-- ##output parentGuid char[36] 父节点guid（上段字节内容guid）;父节点guid（上段字节内容guid）
-- ##output guid char[36] 字节内容guid;字节内容guid
-- ##output name string[20] 字节内容名称;字节内容名称
-- ##output level int[>=0] 1;字节内容所在树形层级
-- ##output norder int[>=0] 1;字节内容排序
-- ##output hasSon int[>=0] 0;是否还有儿子节点（0：否，1-是）,即是否有下一段字节内容关联

select
t.scene_tree_guid as secenGuid
,t.guid
,t.name
,t.parent_guid as parentGuid
,all_parent_id as allParentId
,t.level
,t.norder
from
coz_category_name_tree t
where 
(guid='{nameTreeGuid}') and del_flag='0'