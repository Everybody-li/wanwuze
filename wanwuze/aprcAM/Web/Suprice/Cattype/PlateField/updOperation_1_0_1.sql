-- ##Title web后台-审批模式-通用配置/配置管理-供应报价信息管理-供应报价信息配置-字段名称配置-字段内容配置-需方/供方操作设置
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 修改
-- ##Describe 操作后每次都调用接口改主表发布状态：aprcAM\Web\Suprice\Cattype\Mode\updPublishFlag2UnPub_1_0_1
-- ##Describe 表名前缀获取：aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1
-- ##Describe 表名：表名前缀_plate_field t1
-- ##CallType[ExSql]

-- ##input bizType enum[1,2,3] NOTNULL;业务菜单类型：1-审批模式下的通用或非通用的供应报价信息管理，2-审批报价的采购需求信息配置，3-审批报价的供应报价信息配置
-- ##input bizGuid char[36] NOTNULL;业务guid：品类型号guid或品类类型guid/品类guid，有型号guid传型号guid，没有则传品类类型guid/品类guid
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input operation enum[1,2,3,4,5] NOTNULL;操作设置：1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传
-- ##input placeholder string[500] NULL;操作提示语
-- ##input fileTemplate string[42] NULL;文件/图片模板，目录：aprcAM/Web/Suprice/PLATEFIELD/{入参bizType值}/{模板文件guid首字母}/
-- ##input curUserId char[36] NOTNULL;当前登录用户id

update {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field
set operation='{operation}'
,placeholder ='{placeholder}'
,file_template ='{fileTemplate}'
,update_by='{curUserId}'
,update_time=now()
where guid='{plateFieldGuid}' 
;
{file[aprcAM\Web\Suprice\Cattype\Price\updPublishFlag2UnPub_1_0_1.sql]/file}
