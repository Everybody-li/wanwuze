-- ##Title web-删除板块名称
-- 使用方:WebAPP
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-删除板块名称
-- ##CallType[ExSql]

-- ##input plateGuid char[36] NOTNULL;板块guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填



set @categoryGuid = null;

select category_guid
into @categoryGuid
from
    coz_model_chat_plate
where guid = '{plateGuid}';

update coz_category_chat_mode
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
where category_guid = @categoryGuid;


update coz_model_chat_plate_field_content
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where plate_field_guid in (select guid from coz_model_chat_plate_field where plate_guid='{plateGuid}')
;
update coz_model_chat_plate_field
set del_flag='2'
,publish_flag=0
,update_by='{curUserId}'
,update_time=now()
where plate_guid='{plateGuid}'
;
update coz_model_chat_plate
set del_flag='2'
,publish_flag=0
,update_by='{curUserId}'
,update_time=now()
where guid='{plateGuid}'