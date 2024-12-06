-- ##Title 根据code模糊查询数据
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据code模糊查询数据
-- ##CallType[QueryData]

-- ##output code string[30] NULL;区域编码，必填


select 
parent_code as parentCode
,code
,name
,id
,level
from sys_city_code t
where (code like '{code}%' or '{code}'='') and version=1
order by code