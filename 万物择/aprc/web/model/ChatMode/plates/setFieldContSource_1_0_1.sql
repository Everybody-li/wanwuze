-- ##Title web-设置字段内容来源
-- 使用方:WebAPP
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describeweb-设置字段内容来源
-- ##CallType[ExSql]

-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid，必填
-- ##input contentSource int[>=0] NOTNULL;字段内容来源（1-固化，2-自建，3-需方），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


set @categoryGuid = null;

select category_guid
into @categoryGuid
from
    coz_model_chat_plate_field
where guid = '{plateFieldGuid}';

update coz_category_chat_mode
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
where category_guid = @categoryGuid;


update coz_model_chat_plate_field
set content_source='{contentSource}'
,publish_flag='0'
,update_by='{curUserId}'
,update_time=now()
where guid='{plateFieldGuid}'
;
update coz_model_chat_plate_field_content
set del_flag='2'
,publish_flag='0'
,update_by='{curUserId}'
,update_time=now()
where plate_field_guid='{plateFieldGuid}'
;