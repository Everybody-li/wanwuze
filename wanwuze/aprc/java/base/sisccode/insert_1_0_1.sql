-- ##Title 新增国标数据
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 新增国标数据
-- ##CallType[ExSql]

-- ##input name string[30] NOTNULL;名称，必填
-- ##input code string[12] NOTNULL;编码，必填
-- ##input parentCode string[11] NOTNULL;父节点编码，必填
-- ##input allParentCode string[100] NOTNULL;组系节点编码，必填
-- ##input level int[>=0] NOTNULL;层级，必填
-- ##input orderNum int[>=0] NOTNULL;排序，必填
-- ##input pathName string[120] NOTNULL;全路径名称，必填

INSERT INTO sys_isic_code(guid,all_parent_code,path_name,name,code,parent_code,order_num,level,del_flag,create_by,create_time,update_by,update_time)
select 
uuid()
,'{allParentCode}'
,'{pathName}'
,'{name}'
,'{code}'
,'{parentCode}'
,{orderNum}
,{level}
,'0'
,'1'
,now()
,'1'
,now() 
