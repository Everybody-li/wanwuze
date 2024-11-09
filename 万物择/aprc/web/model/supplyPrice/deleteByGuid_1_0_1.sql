-- ##Title web-删除供应报价信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除供应报价信息
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_supply_price
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where category_guid='{categoryGuid}'
;
update coz_model_plate
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where category_guid='{categoryGuid}' and biz_type='2'
;
update coz_model_plate_field
set del_flag='2'
,update_time = now()
,update_by = '{curUserId}'
where category_guid='{categoryGuid}' and biz_type='2'
;
update coz_model_plate_field_content
set del_flag='2'
,update_time = now()
,update_by = '{curUserId}'
where category_guid='{categoryGuid}' and biz_type='2'
;
update coz_model_plate_formal
set del_flag='2'
,update_time = now()
,update_by = '{curUserId}'
where category_guid='{categoryGuid}' and biz_type='2'
;
update coz_model_plate_field_formal
set del_flag='2'
,update_time = now()
,update_by = '{curUserId}'
where category_guid='{categoryGuid}' and biz_type='2'
;
update coz_model_plate_field_content_formal
set del_flag='2'
,update_time = now()
,update_by = '{curUserId}'
where category_guid='{categoryGuid}' and biz_type='2'
;


