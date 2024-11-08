-- ##Title 代理端-java-固化字段内容-c00024-企业业务类型-数据插入
-- ##Author 卢文彪
-- ##CreateTime 2023-09-21
-- ##Describe 表名:sys_enttype_code
-- ##CallType[ExSql]

-- ##input allParentCode string[100] NOTNULL;组系节点code
-- ##input parentCode string[10] NOTNULL;父节点编码code
-- ##input code string[20] NOTNULL;节点编码code
-- ##input name string[30] NOTNULL;节点名称
-- ##input pathName string[100] NOTNULL;全路径名称
-- ##input orderNum int[>=0] NOTNULL;排序
-- ##input level int[>=0] NOTNULL;层级

insert into sys_enttype_code
(
guid
,all_parent_code
,path_name
,name
,code
,parent_code
,order_num
,level
,end_nodes_count
,del_flag
,create_by
,create_time
,update_by
,update_time
)
select
uuid()
,'{allParentCode}'
,'{pathName}'
,'{name}'
,'{code}'
,'{parentCode}'
,'{orderNum}'
,'{level}'
,'0'
,'0'
,'0'
,now()
,'0'
,now()

