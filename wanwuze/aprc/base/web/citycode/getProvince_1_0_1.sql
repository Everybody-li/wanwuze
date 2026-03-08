-- ##Title 查询省列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 查询省列表
-- ##CallType[QueryData]



select 
code
,path_name as pathName
from sys_city_code t
where t.level=1
order by code
