-- ##Title 清除生成品类产生的临时值
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 清除生成品类产生的临时值
-- ##CallType[ExSql]

update coz_category_deal_mode t
set publish_time=now()
where (cattype_guid='{categoryGuid}' and exists(select 1 from coz_model_plate_formal where temp_guid is not null and category_guid=t.category_guid and biz_type='1')) or category_guid='{categoryGuid}'
;
update coz_model_plate_field_content
set publish_flag='2'
where category_guid='{categoryGuid}' and biz_type='1'
;
update coz_model_plate_field
set publish_flag='2'
where category_guid='{categoryGuid}' and biz_type='1'
;
update coz_model_plate
set publish_flag='2'
where category_guid='{categoryGuid}' and biz_type='1'
;
update coz_model_plate_field_content t
left join
coz_model_plate_field t1
on t.plate_field_guid=t1.temp_guid and t.category_guid=t1.category_guid
set t.plate_field_guid=t1.guid
,t.temp_guid=null
,t.del_flag='0'
,t.publish_flag='2'
where (t.temp_guid is not null and t.temp_guid<>'') and t.del_flag='2' and t.biz_type='1' and t.cattype_guid='{categoryGuid}' and t1.guid is not null and t.category_guid<>'{categoryGuid}'
;
update coz_model_plate_field t
left join
coz_model_plate t1
on t.plate_guid=t1.temp_guid and t.category_guid=t1.category_guid
set t.plate_guid=t1.guid
,t.temp_guid=null
,t.del_flag='0'
,t.publish_flag='2'
,t.publish_time=now()
where (t.temp_guid is not null and t.temp_guid<>'') and t.del_flag='2' and t.biz_type='1' and t.cattype_guid='{categoryGuid}' and t1.guid is not null and t.category_guid<>'{categoryGuid}'
;

update coz_model_plate
set temp_guid=null
,del_flag='0'
,publish_flag='2'
,publish_time=now()
where (temp_guid is not null and temp_guid<>'') and del_flag='2' and biz_type='1' and cattype_guid='{categoryGuid}' and category_guid<>'{categoryGuid}'
;
update coz_model_plate_field_content_formal t
left join
coz_model_plate_field_formal t1
on t.plate_field_formal_guid=t1.temp_guid and t.category_guid=t1.category_guid
set t.plate_field_formal_guid=t1.guid
,t.temp_guid=null
,t.del_flag='0'
where (t.temp_guid is not null and t.temp_guid<>'') and t.del_flag='2' and t.biz_type='1' and t.cattype_guid='{categoryGuid}' and t1.guid is not null
;
update coz_model_plate_field_formal t
left join
coz_model_plate_formal t1
on t.plate_formal_guid=t1.temp_guid and t.category_guid=t1.category_guid
set t.plate_formal_guid=t1.guid
,t.temp_guid=null
,t.del_flag='0'
where (t.temp_guid is not null and t.temp_guid<>'') and t.del_flag='2' and t.biz_type='1' and t.cattype_guid='{categoryGuid}' and t1.guid is not null
;
update coz_model_plate_formal
set temp_guid=null
,del_flag='0'
where (temp_guid is not null and temp_guid<>'') and del_flag='2' and biz_type='1' and cattype_guid='{categoryGuid}'
;
