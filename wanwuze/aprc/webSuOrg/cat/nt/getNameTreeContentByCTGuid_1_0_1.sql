-- ##Title app-按品类定义查询-获取品类字节内容列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-按品类定义查询-获取品类字节内容列表
-- ##CallType[QueryData]

-- ##input sceneGuid char[36] NOTNULL;末级场景guid，必填
-- ##input parentGuid char[36] NOTNULL;父字节内容guid（当level=1，parentGuid=catTreeGuid），必填
-- ##input name string[50] NULL;字节内容名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output nameTreeGuid char[36] 字节内容guid;字节内容guid
-- ##output sceneGuid char[36] 末级场景guid;末级场景guid
-- ##output level int[>=0] 1;字节内容所在树形层级
-- ##output name string[20] 字节内容名称;字节内容名称
-- ##output norder int[>=0] 1;字节内容排序

PREPARE q1 FROM '
select
t.guid as nameTreeGuid
,t.scene_tree_guid as sceneGuid
,t.level
,t.name
,t.norder
from
coz_category_name_tree t
where 
t.scene_tree_guid=''{sceneGuid}'' and t.del_flag=''0''  and t.parent_guid=''{parentGuid}'' and (t.name like ''{name}%'' or ''{name}''='''')
order by t.norder,t.id
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;