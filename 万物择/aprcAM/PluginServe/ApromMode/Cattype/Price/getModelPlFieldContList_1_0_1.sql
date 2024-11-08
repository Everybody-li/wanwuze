-- ##Title 插件端-web后台-审批模式-通用配置-供应报价信息管理-发布逻辑-查询供方型号产品介绍字段内容列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe 查询： 只查询非固化字段内容库(即自建库：plate_field_content_gc为空的)，一个字段名下供方可能选择了多个字段内容
-- ##Describe 表名：coz_category_supplier_am_model_price_plate
-- ##CallType[QueryData]

select t.plate_field_formal_guid as plateFieldGuid
     , t.model_guid              as modelGuid
     , t.operation
     , if(plate_field_content_gc is not null and plate_field_content_gc <> '', plate_field_content_gc,
          t.plate_field_value)   as plateFieldValue
from coz_category_supplier_am_model model
         inner join coz_category_supplier_am_model_plate t on model.guid = t.model_guid
where model.supplier_guid = '{supplierGuid}'
  and model.del_flag = '0'
  and t.del_flag = '0'
  and t.status = '1'
-- group by t.plate_field_formal_guid, t.plate_field_value

