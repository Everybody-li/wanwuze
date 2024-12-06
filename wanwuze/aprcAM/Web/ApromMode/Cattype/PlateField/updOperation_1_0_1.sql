-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购/供应需求信息配置-字段名称配置-字段内容配置-需方/供方操作设置
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 修改： 根据字段名称guid和供需区分修改
-- ##Describe 操作后每次都调用接口改主表发布状态：aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1
-- ##Describe 表名：coz_model_am_aprom_plate_field_settings t1
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分：demand-采购需求，supply-供应需求
-- ##input operation enum[1,2,3,4,5] NOTNULL;操作设置：1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传
-- ##input placeholder string[500] NULL;供/需方操作提示信息
-- ##input fileTemplate string[42] TNULL;文件/图片模板,目录:APRC/WEB/APROM/MODE/PLATEFIELD/{模板文件guid首字母}/ ，注意：要是有文件上传的，一定要先文件上传成功再调用接口保存数据
-- ##input curUserId char[36] NOTNULL;当前登录用户id

update coz_model_am_aprom_plate_field_settings
set operation='{operation}'
,placeholder ='{placeholder}'
,file_template ='{fileTemplate}'
,update_by='{curUserId}'
,update_time=now()
where plate_field_guid='{plateFieldGuid}' and  cat_tree_code='{catTreeCode}'
;
{file[aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1.sql]/file}
