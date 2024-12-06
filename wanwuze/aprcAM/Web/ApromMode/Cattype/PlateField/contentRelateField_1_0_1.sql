-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购/供应需求信息配置-字段名称配置-字段内容配置-字段内容管理-关联字段名称
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 修改，将当前字段内容关联字段名称
-- ##Describe 操作后每次都调用接口改主表发布状态：aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1
-- ##Describe 表名：coz_model_am_aprom_plate_field_content t1
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类类型guid/品类guid
-- ##input plateFieldContentGuid char[36] NOTNULL;字段内容guid
-- ##input plateFieldGuid char[36] NOTNULL;要关联的字段名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

update coz_model_am_aprom_plate_field_content
set relate_field_guid='{plateFieldGuid}'
,update_by='{curUserId}'
,update_time=now()
where guid='{plateFieldContentGuid}'
;
{file[aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1.sql]/file}
