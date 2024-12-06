-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购需求信息配置-字段名称配置-清空字段名称
-- ##Author 卢文彪
-- ##CreateTime 2023-07-25
-- ##Describe 删除当前品类名称的所有字段名称及字段名称关联的设置信息、字段内容信息，操作后每次都调用接口改主表发布状态：aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1
-- ##Describe 表名：coz_model_am_aprom_plate_field t1,coz_model_am_aprom_plate_field_settings t2,coz_model_am_aprom_plate_field_content t3
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类类型guid/品类guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id


update coz_model_am_aprom_plate_field_content t
inner join
coz_model_am_aprom_plate_field t1
on t.relate_field_guid=t1.guid
set t.relate_field_guid=''
,t.update_by='{curUserId}'
,t.update_time=now()
where t1.category_guid='{categoryGuid}'
;
update coz_model_am_aprom_plate_field
set del_flag='2'
  ,update_by='{curUserId}'
  ,update_time=now()
where category_guid='{categoryGuid}'
;
update coz_model_am_aprom_plate_field_settings
set del_flag='2'
  ,update_by='{curUserId}'
  ,update_time=now()
where category_guid='{categoryGuid}'
;
update coz_model_am_aprom_plate_field_content
set del_flag='2'
  ,update_by='{curUserId}'
  ,update_time=now()
where category_guid='{categoryGuid}'
;


{file[aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1.sql]/file}
