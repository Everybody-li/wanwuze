-- ##Title web后台-审批模式-通用配置/配置管理-供应报价信息管理-供应报价信息配置-字段名称配置-新建字段名称
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 新增t1，同一品类下字段名称不可重复，操作后每次都调用接口改主表发布状态：aprcAM\Web\Suprice\Cattype\Price\updPublishFlag2UnPub_1_0_1
-- ##Describe 表名前缀获取：aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1
-- ##Describe 表名：表名前缀_plate_field t1
-- ##CallType[ExSql]

-- ##input bizType enum[1,2,3] NOTNULL;业务菜单类型：1-审批模式下的通用或非通用的供应报价信息管理，2-审批报价的采购需求信息配置，3-审批报价的供应报价信息配置
-- ##input bizGuid char[36] NOTNULL;业务guid：品类型号guid或品类类型guid/品类guid，有型号guid传型号guid，没有则传品类类型guid/品类guid
-- ##input categoryGuid char[36] NOTNULL;品类型号guid或品类类型guid/品类guid
-- ##input plateFieldName string[30] NOTNULL;板块字段名称
-- ##input curUserId char[36] NOTNULL;当前登录用户id

insert into {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field
(
guid
,cattype_guid
,category_guid
,biz_guid
,plate_guid
,name
,alias
,source
,norder
,del_flag
,create_by
,create_time
,update_by
,update_time
)
select
UUID() as guid
,'{categoryGuid}' as cattype_guid
,'{categoryGuid}' as category_guid 
,'{bizGuid}' as biz_guid
,'' as plateGuid
,'{plateFieldName}' as name
,'{plateFieldName}' as alias
,'2' as source
,ifnull((select (max(norder)+1) from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field where del_flag='0' and biz_guid='{bizGuid}' ),1) as norder
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now()as update_time
;
{file[aprcAM\Web\Suprice\Cattype\Price\updPublishFlag2UnPub_1_0_1.sql]/file}

