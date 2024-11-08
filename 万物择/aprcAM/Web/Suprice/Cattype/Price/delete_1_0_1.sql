-- ##Title web后台-审批模式配置管理-供应报价信息管理-删除供应报价信息
-- ##Author 卢文彪
-- ##CreateTime 2023-08-20
-- ##Describe 删除，删除供应报价信息主表、日志表及其相关子表数据
-- ##Describe 表名：coz_category_am_suprice,coz_category_am_suprice_log,
-- ##Describe 表名： coz_model_am_suprice_plate,coz_model_am_suprice_plate_field,coz_model_am_suprice_plate_field_content
-- ##Describe 表名：coz_model_am_suprice_plate_formal,coz_model_am_suprice_plate_field_formal,coz_model_am_suprice_plate_field_content_formal
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id



update coz_category_am_suprice
set del_flag='2'
where category_guid='{categoryGuid}'
;
delete from coz_category_am_suprice_log where category_guid='{categoryGuid}'
;
update coz_model_am_suprice_plate
set del_flag='2'
  ,update_by='{curUserId}'
  ,update_time=now()
where category_guid='{categoryGuid}'
;
update coz_model_am_suprice_plate_field
set del_flag='2'
  ,update_by='{curUserId}'
  ,update_time=now()
where category_guid='{categoryGuid}'
;
update coz_model_am_suprice_plate_field_content
set del_flag='2'
  ,update_by='{curUserId}'
  ,update_time=now()
where category_guid='{categoryGuid}'
;
