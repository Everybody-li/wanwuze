-- ##Title 插件端-web后台-审批模式-供需需求信息管理-发布逻辑-查询渠道需求字段名称内容列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe 查询：
-- ##Describe 表名：coz_aprom_pre_demand_request_plate
-- ##CallType[QueryData]


select t.request_guid                  as preRequestGuid
     , t.plate_field_formal_guid       as plateFieldGuid
     , t.operation
     , t.plate_field_relate_field_guid as plateFieldRelateFieldGuid
     , if(plate_field_content_gc is not null and plate_field_content_gc <> '', plate_field_content_gc,
          t.plate_field_value)         as plateFieldValue
from coz_aprom_pre_demand_request pdr
         inner join coz_aprom_pre_demand_request_plate t on pdr.guid = t.request_guid
where pdr.category_guid = '{categoryGuid}'
  and pdr.del_flag = '0'
  and t.del_flag = '0'
  and t.status = '1'


