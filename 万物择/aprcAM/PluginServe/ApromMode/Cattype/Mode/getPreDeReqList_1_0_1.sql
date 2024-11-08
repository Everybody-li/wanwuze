-- ##Title 插件端-web后台-审批模式-通用配置-供需需求信息管理-发布逻辑-查询渠道需求
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe 
-- ##Describe 表名：coz_category_supplier_am_model
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output preRequestGuid char[36] 供方品类型号guid;供方品类型号guid
-- ##output DeReq.plateFieldGuid char[36] 字段名称guid;字段名称guid
-- ##output DeReq.plateFieldValue string[200] 用户填写的值;用户填写的值，存具体内容，例如输入的字符内容

select
t.guid as preRequestGuid
,CONCAT('{ChildRows_aprcAM\\PluginServe\\ApromMode\\Cattype\\Mode\\getPreDeReqFieldList_1_0_1:preRequestGuid=''',t.GUID,'''}') as `DeReq`
from
coz_aprom_pre_demand_request t
where 
t.category_guid = '{categoryGuid}' and t.del_flag='0'
order by t.id