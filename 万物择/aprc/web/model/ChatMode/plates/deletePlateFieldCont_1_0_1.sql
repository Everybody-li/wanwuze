-- ##Title web-删除/移除字段内容（固化库/自建库）
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-删除/移除字段内容（固化库/自建库）
-- ##CallType[ExSql]

-- ##input fieldContentGuid char[36] NOTNULL;字段名称内容guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


set @categoryGuid = null;

select category_guid
into @categoryGuid
from
    coz_model_chat_plate_field_content
where guid = '{fieldContentGuid}';

update coz_category_chat_mode
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
where category_guid = @categoryGuid;

update coz_model_chat_plate_field_content
set del_flag='2' 
,publish_flag='0'
,update_by='{curUserId}'
,update_time=now()
where guid='{fieldContentGuid}'
;
