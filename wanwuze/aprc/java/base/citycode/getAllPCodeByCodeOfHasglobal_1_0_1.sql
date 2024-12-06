-- ##Title 根据code精准查询组系节点code数据-行政区域(全球至区县)
-- ##Author lith
-- ##CreateTime 2023-05-28
-- ##Describe  sys_city_code_hasglobal
-- ##CallType[QueryData]


-- ##input code string[30] NOTNULL;区域编码，必填


select 
all_parent_code as allParentCode
,code
from sys_city_code_hasglobal t
where code ='{code}'

;
