-- ##Title 查询城镇列表
-- ##Author lith
-- ##CreateTime 2020-06-05
-- ##Describe 查询城镇列表
-- ##CallType[QueryData]

-- ##input parentCode string[30] NOTNULL;父级code，必填

select
guid
,code
,path_name as pathName
from sys_city_code t
where parent_code='{parentCode}'
order by code
