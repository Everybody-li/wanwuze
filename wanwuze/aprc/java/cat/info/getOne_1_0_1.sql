-- ##Title 品类-根据品类guid查询品类信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 品类-根据品类guid查询品类信息
-- ##Describe coz_category_scene_tree coz_category_supplydemand  coz_cattype_sd_path
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填

-- ##output guid string[50] 品类guid;品类guid
-- ##output name string[50] 品类名称;品类名称
-- ##output cattypeGuid string[50] 品类类型guid;品类类型guid
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output mode int[>=0] 1;品类模式
-- ##output categoryTime string[30] ;品类创建时间
-- ##output sdPathGuid char[36] ;采购供应路径关联guid
-- ##output sdPathAllName string[100] ;采购供应路径全节点名称

select
t.guid
,t.name
,t.alias
,t.img
,t.cattype_guid as cattypeGuid
,t.cattype_name as cattypeName
,t.mode
,t.create_time as categoryTime
,t2.sd_path_guid as sdPathGuid
,t3.name as sdPathAllName
from
coz_category_info t
inner join
coz_category_supplydemand t1
on t.guid=t1.category_guid
inner join
coz_category_scene_tree t2
on t1.scene_tree_guid=t2.guid
inner join
coz_cattype_sd_path t3
on t2.sd_path_guid=t3.guid
where 
t.guid='{categoryGuid}' and t.del_flag='0' 