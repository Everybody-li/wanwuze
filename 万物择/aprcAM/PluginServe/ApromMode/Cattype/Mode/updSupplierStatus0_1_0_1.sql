-- ##Title 插件端-web后台-审批模式-通用配置-供需需求信息管理-发布逻辑-修改供方型号字段名称为失效
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe 查询： 修改生效标志为失效
-- ##Describe 表名：coz_category_supplier_am_model_plate
-- ##CallType[ExSql]

-- ##input modelGuid char[36] NOTNULL;供方品类型号guid
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

update coz_category_supplier_am_model_plate
set status='0'
,update_by='{curUserId}'
,update_time=now()
where model_guid='{modelGuid}' and plate_field_formal_guid='{plateFieldGuid}'
;
