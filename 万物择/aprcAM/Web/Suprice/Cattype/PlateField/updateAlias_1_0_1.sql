-- ##Title web后台-审批模式-通用配置/配置管理-供应报价信息管理-供应报价信息配置-字段名称配置-修改字段别名
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 修改t1，操作后每次都调用接口改主表发布状态：aprcAM\Web\Suprice\Cattype\Price\updPublishFlag2UnPub_1_0_1
-- ##Describe 表名前缀获取：aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1
-- ##Describe 表名：表名前缀_plate_field t1
-- ##CallType[ExSql]

-- ##input bizType enum[1,2,3] NOTNULL;业务菜单类型：1-审批模式下的通用或非通用的供应报价信息管理，2-审批报价的采购需求信息配置，3-审批报价的供应报价信息配置
-- ##input bizGuid char[36] NOTNULL;业务guid：品类型号guid或品类类型guid/品类guid，有型号guid传型号guid，没有则传品类类型guid/品类guid
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input plateFieldAlias string[50] NOTNULL;字段别名，必填
-- ##input curUserId char[36] NOTNULL;当前登录用户id

update {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field
set alias='{plateFieldAlias}'
,update_by='{curUserId}'
,update_time=now()
where guid='{plateFieldGuid}'
;
{file[aprcAM\Web\Suprice\Cattype\Price\updPublishFlag2UnPub_1_0_1.sql]/file}

