-- ##Title 品类-根据品类guid查询品类信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 品类-根据品类guid查询品类信息
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填

-- ##output guid string[50] 品类guid;品类guid
-- ##output name string[50] 品类名称;品类名称
-- ##output cattypeGuid string[50] 品类类型guid;品类类型guid
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output mode int[>=0] 1;品类模式


select
t.guid
,t.name
,t.cattype_guid as cattypeGuid
,t.cattype_name as cattypeName
,t.mode
from
coz_category_info t
where 
t.guid='{categoryGuid}' and t.del_flag='0' 