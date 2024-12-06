-- ##Title 固化字段内容-c00024-企业业务类型-app-无选中状态-获取企业业务类型数据（弃用）
-- ##Author 卢文彪
-- ##CreateTime 2023-09-21
-- ##Describe 表名:sys_enttype_code
-- ##CallType[QueryData]

-- ##input parentCode string[20] NOTNULL;父节点编码code(顶级code：0)

-- ##output code string[20] A01;节点编码code
-- ##output name string[30] 土木工程建筑业;节节点名称
-- ##output pathName string[100] 商品供应模式>不动产品供应土>木工程建筑业;全路径名称
-- ##output hasSon enum[0,1] 0;是否有儿子(0：无儿子，1：有儿子)




select code
     , t.name
     , path_name  as pathName
,case when exists(select 1 from sys_enttype_code where parent_code=t.code and del_flag='0') then '1' else 0 end as hasSon
from sys_enttype_code t
where t.parent_code = '{parentCode}'
  and t.del_flag = '0' 
order by t.order_num;