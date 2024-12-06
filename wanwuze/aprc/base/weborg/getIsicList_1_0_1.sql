-- ##Title web-无选中状态-获取国标行业数据
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-无选中状态-获取国标行业数据
-- ##CallType[QueryData]

-- ##input parentCode string[11] NOTNULL;父节点code(顶级code：0)，必填

select 
code
,name
,level
,path_name as pathName
,case when exists(select 1 from sys_isic_code where parent_code=t.code and del_flag='0') then '1' else '0' end as hasSon
from sys_isic_code t
where t.parent_code='{parentCode}'
order by code