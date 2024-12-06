-- ##Title web后台-审批模式-通用配置/配置管理-供应报价信息管理-供应报价信息配置-字段名称配置-清空字段名称
-- ##Author 卢文彪
-- ##CreateTime 2023-07-25
-- ##Describe  删除当前品类名称的所有字段名称及字段名称的字段内容信息，操作后每次都调用接口改主表发布状态：aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1
-- ##CallType[ExSql]

-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id


update coz_model_am_aprom_plate_field_content
set del_flag='2'
  ,update_by='{curUserId}'
  ,update_time=now()
where  plate_field_guid='{plateFieldGuid}'
;
{file[aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1.sql]/file}
