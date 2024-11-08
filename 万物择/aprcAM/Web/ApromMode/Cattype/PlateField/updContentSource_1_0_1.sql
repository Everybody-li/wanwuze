-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购/供应需求信息配置-字段名称配置-字段内容配置-内容来源设置
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 修改
-- ##Describe 操作后每次都调用接口改主表发布状态：aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1
-- ##Describe 表名：coz_model_am_aprom_plate_field_settings t1
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分：demand-采购需求，supply-供应需求
-- ##input contentSource enum[1,2,3] NOTNULL;内容来源：1-字段内容固化库，2-字段内容自建库，3-操作用户方(需方或供方)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

update coz_model_am_aprom_plate_field_settings
set content_source='{contentSource}'
,update_by='{curUserId}'
,update_time=now()
where plate_field_guid='{plateFieldGuid}' and cat_tree_code='{catTreeCode}'
;
update coz_model_am_aprom_plate_field
set 
content_fixed_data_guid=case when ('{contentSource}'<>'1') then '' else content_fixed_data_guid end
-- ,source=case when ('{contentSource}'='1') then '1' when ('{contentSource}'='2') then '2' else source end
,update_by='{curUserId}'
,update_time=now()
where guid='{plateFieldGuid}'
;
update coz_model_am_aprom_plate_field_content
set del_flag='2'
where plate_field_guid='{plateFieldGuid}' and '{contentSource}'='1'
;
{file[aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1.sql]/file}
