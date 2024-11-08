-- ##Title 插件端-web后台-审批模式-供需需求信息管理-发布逻辑-查询供方型号字段名称列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe 查询： 
-- ##Describe 表名：coz_category_supplier_am_model_plate
-- ##CallType[QueryData]


select t.model_guid                                                            as modelGuid
     , t.plate_field_formal_guid                                               as plateFieldGuid
     , CONCAT(
        '{ChildRows_aprcAM\\PluginServe\\ApromMode\\Cattype\\Mode\\getModelPlFieldContList_1_0_1:plateFieldGuid=''',
        t.plate_field_formal_guid, ''' and modelGuid=''', t.model_guid, '''}') as `fields`
from coz_category_supplier_am_model model
         inner join coz_category_supplier_am_model_plate t on model.guid = t.model_guid
where model.supplier_guid = '{supplierGuid}'
  and model.del_flag = '0'
  and t.del_flag = '0'
  and t.status = '1'
group by t.model_guid, t.plate_field_formal_guid
