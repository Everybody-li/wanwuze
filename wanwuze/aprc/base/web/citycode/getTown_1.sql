-- ##Title 查询城镇列表
-- ##Author lith
-- ##CreateTime 2020-06-05
-- ##Describe 查询城镇列表
-- ##CallType[QueryData]

-- ##input parentCode string[11] NOTNULL;父级code，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
code
,parent_code as parentCode
from sys_city_code t
where parent_code='{parentCode}'
order by code
