-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购需求信息配置-字段名称配置-修改字段别名
-- ##Author 卢文彪
-- ##CreateTime 2023-07-25
-- ##Describe 修改t1，操作后每次都调用接口改主表发布状态：aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1
-- ##Describe 表名：coz_model_am_aprom_plate_field t1
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;当前登录用户id
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input plateFieldAlias string[50] NOTNULL;字段别名，必填
-- ##input curUserId char[36] NOTNULL;当前登录用户id

update coz_model_am_aprom_plate_field
set alias='{plateFieldAlias}'
,update_by='{curUserId}'
,update_time=now()
where guid='{plateFieldGuid}'
;
{file[aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1.sql]/file}

