-- ##Title 审批模式-供方型号-根据型号guid批量查询型号内容列表
-- ##Author 卢文彪
-- ##CreateTime 2023-08-04
-- ##Describe 查询
-- ##Describe coz_category_supplier_am_model_plate t1
-- ##CallType[QueryData]

select
t.model_guid as modelGuid
,t.plate_field_formal_guid as plateFieldGuid
,t.plate_field_value as plateFieldValue
,t.plate_field_content_gc as plateFieldContentCode
from
coz_category_supplier_am_model_plate t
where
t.model_guid in ({modelGuid}) and t.del_flag='0' and status='1' and operation in ('1','2','3')
