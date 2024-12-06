-- ##Title 根据末级场景获取末级场景祖辈列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据末级场景获取品类字节内容列表
-- ##CallType[QueryData]

-- ##input secenGuid char[36] NOTNULL;末级场景guid，必填

-- ##output guid char[36] 品类供需树guid;品类供需树guid
-- ##output name string[20] 品类供需树节点名称;品类供需树节点名称
-- ##output parentGuid char[36] 品类供需树父guid;品类供需树父guid

select
t.guid
,t.name
,t.parent_guid as parentGuid
,t.sd_path_guid as sdPathGuid
,t1.cattype_guid as cattypeGuid
,t2.name as cattypeName
from
coz_category_scene_tree t
left join
coz_cattype_sd_path t1
on t.sd_path_guid=t1.guid
left join
coz_cattype_fixed_data t2
on t1.cattype_guid=t2.guid
where 
t.id in({url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\java\cat\secen\allParentId&DBC=w_a&secenGuid={secenGuid}&OnlyTagReturn=true]/url}) and t.del_flag=0
order by t.norder