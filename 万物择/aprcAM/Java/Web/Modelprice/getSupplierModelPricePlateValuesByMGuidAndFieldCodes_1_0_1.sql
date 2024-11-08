-- ##Title 审批模式-供方型号-根据型号guid及固化字段名称code批量查询型号产品介绍内容列表
-- ##Author lith
-- ##CreateTime 2023-11-03
-- ##Describe 查询 利息范围和额度范围
-- ##Describe coz_category_supplier_am_model_price_plate t1
-- ##CallType[QueryData]


select t.model_guid              as modelGuid
     , t.plate_field_formal_guid as plateFieldGuid
     , t.plate_field_value       as plateFieldValue
     , t.plate_field_code        as plateFieldCode
from coz_category_supplier_am_model_price_plate t
where t.model_guid in ({modelGuid})
  and t.del_flag = '0'
  and status = '1'
  and plate_field_code in ('f00063', 'f00064')
