-- ##Title 企业业务code-根据code精准查询组系节点code数据
-- ##Author lith
-- ##CreateTime 2023-05-28
-- ##Describe 表名:sys_enttype_code
-- ##CallType[QueryData]


-- ##input code string[30] NOTNULL;区域编码，必填


select all_parent_id as allParentCode
     , id
from coz_model_fixed_data_value t
where guid = '{code}'
;
