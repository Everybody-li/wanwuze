-- ##Title app-获取品类字节标题列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-获取品类字节标题列表
-- ##CallType[QueryData]

-- ##input sceneGuid char[36] NOTNULL;末级场景guid，必填

-- ##output titleGuid char[36] 字节标题guid;字节标题guid
-- ##output sceneGuid char[36] 末级场景guid;末级场景guid
-- ##output level int[>=0] 序号;序号,第几段
-- ##output name string[50] 标题名称;标题名称
-- ##output create_time_time string[19] 创建时间;创建时间（格式：0000-00-00 00:00:00）

select
t.guid as titleGuid
,t.scene_tree_guid as catTreeGuid
,t.level
,t.name
,t.create_time as createTime
from
coz_category_name_title t
where 
scene_tree_guid='{sceneGuid}' and del_flag=0
order by t.level