-- ##Title 根据品类名称查询品类重复及关联情况
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据品类名称查询品类重复及关联情况
-- ##CallType[QueryData]

-- ##input cattypeGuid char[36] NOTNULL;品类类型guid（1个），必填

-- ##output categoryGuid char[36] 品类名称guid;品类名称guid
-- ##output categoryName string[200] 品类名称;品类名称
-- ##output parentGuid char[36] 字节内容父guid;字节内容父guid
-- ##output exists string[1] 1;重复标志（0：不存在，1：已存在）
-- ##output secenGuids char[36] 关联的末级场景guid;关联的末级场景guid

select
t.guid as categoryGuid
,t.name as categoryName
,case when exists(select 1 from coz_category_info where name=t.name and del_flag=0 and cattype_guid=t.cattype_guid) then '1' else '0' end as `exists`
,CONCAT('{ChildRows_aprc\\java\\cat\\info\\getNameRepSDList_1_0_1:categoryGuid=''',t.guid,'''}') as `secenGuids`
from
coz_category_info t
where 
t.name in({categoryName}) and t.del_flag='0' and t.cattype_guid='{cattypeGuid}'
