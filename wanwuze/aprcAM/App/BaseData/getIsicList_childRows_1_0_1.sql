-- ##Title web-无选中状态-获取国标行业数据_查询子集数据
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-无选中状态-获取国标行业数据_查询子集数据
-- ##CallType[QueryData]



-- ##output children.parentCode string[11] 父节点code;
-- ##output children.code string[11] 节点code;
-- ##output children.name string[30] 节点名称;
-- ##output children.level int[>0] 节点层级;
-- ##output children.pathName string[120] 节点全路径名称;


select t.parent_code                                                                           as parentCode,
       t.code                                                                                  as code,
       t.name                                                                                  as name,
       t.level                                                                                 as level,
       t.path_name                                                                             as pathName,

case when (select count(1) from sys_enttype_code where parent_code = t.code and del_flag ='0') >0 then 1 else 0 end as hasSon
from sys_enttype_code t
where  
del_flag='0' and
  parent_code <> '0'
  ;