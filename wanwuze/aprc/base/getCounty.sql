-- ##Title 查询县/区列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 查询县/区列表
-- ##CallType[QueryData]

-- ##output fatherCityId string[11] NOTNULL;城市父id

-- ##output cityId int[>=0] 0;城市id
-- ##output cityGuid char[36] 城市guid;城市guid
-- ##output cityName string[50] 城市名称;城市名称

select 
code as cityId
,id as cityGuid
,name as cityName
,parent_code as parentCode
,code as code
,path_name as pathName
from sys_city_code t
where t.level=3 and parent_code='{fatherCityId}'
order by id