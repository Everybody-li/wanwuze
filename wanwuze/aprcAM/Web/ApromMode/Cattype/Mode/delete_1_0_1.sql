-- ##Title web后台-审批模式配置管理-供需需求信息管理-删除供需需求信息
-- ##Author 卢文彪
-- ##CreateTime 2023-08-20
-- ##Describe 删除，删除供需需求信息主表、日志表及其相关子表数据
-- ##Describe 表名：coz_category_am_aprom_mode,coz_category_am_aprom_mode_log,
-- ##Describe 表名： coz_model_am_aprom_plate,coz_model_am_aprom_plate_field,coz_model_am_aprom_plate_field_settings,coz_model_am_aprom_plate_field_content
-- ##Describe 表名：coz_model_am_aprom_plate_formal,coz_model_am_aprom_plate_field_formal,coz_model_am_aprom_plate_field_settings_formal,coz_model_am_aprom_plate_field_content_formal
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid
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

update coz_category_am_aprom_mode
set del_flag='2'
where category_guid='{categoryGuid}'
;
delete from coz_category_am_aprom_mode_log where category_guid='{categoryGuid}'
;
update coz_model_am_aprom_plate
set del_flag='2'
  ,update_by='{curUserId}'
  ,update_time=now()
where category_guid='{categoryGuid}'
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
