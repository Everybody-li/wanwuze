-- ##Title web-发布供需需求信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-发布供需需求信息
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select count(1) as publishNum from coz_category_deal_mode_log where category_guid='{categoryGuid}'
;
delete from coz_model_plate_field_content_formal where biz_type='1' and category_guid=@category_guid
;
delete from coz_model_plate_formal where biz_type='1' and category_guid=@category_guid
;
delete from coz_model_plate_field_formal where biz_type='1' and category_guid=@category_guid
;
insert into coz_category_deal_mode_log(guid,category_guid,cattype_guid,publish_time,create_by,create_time,update_by,update_time)
select
UUID(),category_guid,cattype_guid,now() as publish_time,'{curUserId}',create_time,'{curUserId}',update_time
from 
coz_category_deal_mode
where category_guid='{categoryGuid}'
order by id desc
limit 1
;
update coz_model_plate
set publish_time=now()
,publish_flag='2'
where
publish_flag='0' and biz_type='1' and category_guid='{categoryGuid}'
;
update coz_model_plate_field
set publish_time=now()
,publish_flag='2'
where
publish_flag='0' and biz_type='1' and category_guid='{categoryGuid}'
;
update coz_model_plate_field_content
set publish_flag='2'
where
publish_flag='0' and biz_type='1' and category_guid='{categoryGuid}'
;
update coz_category_deal_mode
set publish_time=now()
where category_guid='{categoryGuid}'
;