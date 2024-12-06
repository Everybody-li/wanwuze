-- ##Title 新增行政区域数据
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 新增行政区域数据
-- ##CallType[ExSql]

-- ##input name string[30] NOTNULL;名称，必填
-- ##input code string[12] NOTNULL;编码，必填
-- ##input parentCode string[11] NOTNULL;父节点编码，必填
-- ##input pathName string[100] NULL;全路径名称，必填
-- ##input level int[>=0] NOTNULL;层级，必填
-- ##input version int[>=0] NOTNULL;版本，必填
-- ##input endNodesCount int[>=0] NOTNULL;叶子节点数量，必填

INSERT INTO sys_city_code(guid,all_parent_id,path_name,name,code,parent_code,level,version,end_nodes_count)
select 
uuid()
,''
,'{pathName}'
,'{name}'
,'{code}'
,'{parentCode}'
,{level}
,{version}
,{endNodesCount}
