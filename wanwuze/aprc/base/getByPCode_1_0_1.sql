-- ##Title 根据父节点code逐层获取子级数据
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据父节点code逐层获取子级数据
-- ##CallType[QueryData]

-- ##input parentCode string[11] NOTNULL;父节点code

select 
code as cityId
,id as cityGuid
,name
,level
,parent_code as parentCode
,code as code
,path_name as pathName
,case when exists(select 1 from sys_city_code where parent_code=t.code) then '1' else '0' end as hasSon
from sys_city_code t
where t.parent_code='{parentCode}'
order by id
