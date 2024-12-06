-- ##Title web-字段名称关联板块名称
-- 使用方:WebAPP
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-字段名称关联板块名称
-- ##CallType[ExSql]

-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid，必填
-- ##input plateGuid char[36] NOTNULL;板块类型guid，必填
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
  , affect_status = '1'
where category_guid = @categoryGuid and publish_flag = '2';


update coz_model_chat_plate_field
set plate_guid='{plateGuid}'
,publish_flag='0'
where guid='{plateFieldGuid}'
