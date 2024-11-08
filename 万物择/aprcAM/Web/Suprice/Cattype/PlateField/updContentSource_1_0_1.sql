-- ##Title web后台-审批模式-通用配置/配置管理-供应报价信息管理-供应报价信息配置-字段名称配置-字段内容配置-内容来源设置
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 修改，设置字段名称的字段内容来源
-- ##Describe 操作后每次都调用接口改主表发布状态：aprcAM\Web\Suprice\Cattype\Mode\updPublishFlag2UnPub_1_0_1
-- ##Describe 表名前缀获取：aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1
-- ##Describe 表名：表名前缀_plate_field t1
-- ##CallType[ExSql]

-- ##input bizType enum[1,2,3] NOTNULL;业务菜单类型：1-审批模式下的通用或非通用的供应报价信息管理，2-审批报价的采购需求信息配置，3-审批报价的供应报价信息配置
-- ##input bizGuid char[36] NOTNULL;业务guid：品类型号guid或品类类型guid/品类guid，有型号guid传型号guid，没有则传品类类型guid/品类guid
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input contentSource enum[1,2,3] NOTNULL;内容来源：1-字段内容固化库，2-字段内容自建库，3-操作用户方(需方或供方)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

update {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field
set content_source='{contentSource}'
,operation='0'
-- ,source=case when ('{contentSource}'='1') then '1' when ('{contentSource}'='2') then '2' else source end
,content_fixed_data_guid=case when ('{contentSource}'<>'1') then '' else content_fixed_data_guid end
,update_by='{curUserId}'
,update_time=now()
where guid='{plateFieldGuid}' 
;
update {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field_content
set del_flag='2'
where plate_field_guid='{plateFieldGuid}' and '{contentSource}'='1'
;
{file[aprcAM\Web\Suprice\Cattype\Price\updPublishFlag2UnPub_1_0_1.sql]/file}
