-- ##Title 根据id修改组系节点
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据id修改组系节点
-- ##CallType[ExSql]

-- ##input id int[>=0] NOTNULL;区域编码，必填
-- ##input allParentId string[100] NOTNULL;区域祖系节点，必填
-- ##input pathName string[120] NOTNULL;区域全路径名称，必填

update sys_city_code
set 
all_parent_id='{allParentId}'
,path_name='{pathName}'
where id={id}