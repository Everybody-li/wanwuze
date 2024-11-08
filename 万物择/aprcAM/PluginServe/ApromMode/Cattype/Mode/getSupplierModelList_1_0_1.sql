-- ##Title 插件端-web后台-审批模式-通用配置-供需需求信息管理-发布逻辑-查询供方型号列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe 
-- ##Describe 表名：coz_category_supplier_am_model
-- ##CallType[QueryData]

-- ##input supplierGuid char[36] NOTNULL;供方品类guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output modelGuid char[36] 供方品类型号guid;供方品类型号guid
-- ##output model.plateFieldGuid char[36] 字段名称guid;字段名称guid
-- ##output model.plateFieldValue string[200] 用户填写的值;用户填写的值，存具体内容，例如输入的字符内容

select
t.guid as modelGuid
,CONCAT('{ChildRows_aprcAM\\PluginServe\\ApromMode\\Cattype\\Mode\\getModelPlFieldList_1_0_1:modelGuid=''',t.GUID,'''}') as `model`
from
coz_category_supplier_am_model t
where 
t.supplier_guid='{supplierGuid}' and t.del_flag='0'
order by t.id