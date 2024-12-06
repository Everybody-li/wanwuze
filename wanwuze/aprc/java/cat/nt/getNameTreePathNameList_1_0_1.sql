-- ##Title 品类-根据末级字节内容guid获取品类字节内容信息列表_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 品类-根据末级字节内容guid获取品类字节内容信息列表_1_0_1
-- ##CallType[QueryData]

-- ##input nameTreeGuid string[4000] NOTNULL;末级字节内容Guid(支持多个，格式：''guid1','guid2'.....'guidN'')，必填

select 
replace(CONCAT(ifnull((select GROUP_CONCAT(name order by `level`) from coz_category_name_tree  where t.all_parent_id like concat('%,',id,',%') and del_flag='0'),''),',',t.name),',','') as pathname
from 
coz_category_name_tree t
where guid in ({nameTreeGuid}) and del_flag='0'