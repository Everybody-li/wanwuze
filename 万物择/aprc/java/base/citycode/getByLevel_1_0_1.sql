-- ##Title 根据层级查询数据
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据层级查询数据
-- ##CallType[QueryData]

-- ##output level int[>=0] NOTNULL;区域层级，必填
-- ##output code string[30] NULL;区域编码，非必填

select 
parent_code as parentCode
,code
,name
,id
,level
from sys_city_code t
where level={level} and version=1 and (code like '{code}%' or '{code}'='')
order by code