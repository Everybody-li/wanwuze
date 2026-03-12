-- ##Title 查询县/区列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 查询县/区列表
-- ##CallType[QueryData]

-- ##input parentCode string[30] NOTNULL;父级code，必填


select
guid
,code
,path_name as pathName
from sys_city_code t
where parent_code='{parentCode}'
order by code
