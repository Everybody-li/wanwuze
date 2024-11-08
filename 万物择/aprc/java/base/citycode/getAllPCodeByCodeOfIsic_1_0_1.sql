-- ##Title 行业国标-根据code精准查询组系节点code数据
-- ##Author lith
-- ##CreateTime 2023-05-28
-- ##Describe 表名: sys_isic_code
-- ##CallType[QueryData]


-- ##input code string[30] NOTNULL;区域编码，必填


select 
all_parent_code as allParentCode
,code
from sys_isic_code t
where code ='{code}'
;
