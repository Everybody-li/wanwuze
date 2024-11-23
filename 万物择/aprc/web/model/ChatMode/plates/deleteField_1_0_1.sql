-- ##Title web-删除字段名称
-- 使用方:WebAPP
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-删除字段名称
-- ##CallType[ExSql]

-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid，必填
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
where category_guid = @categoryGuid;


# 逻辑删除字段名称
update coz_model_chat_plate_field
set del_flag='2'
  ,update_by='{curUserId}'
  ,update_time=now()
  ,publish_flag=0
where guid='{plateFieldGuid}';


# 逻辑删除供方的字段名称(关联自需方的字段)
update coz_model_chat_plate_field
set del_flag='2'
  ,update_by='{curUserId}'
  ,update_time=now()
  ,publish_flag=0
where demand_pf_guid='{plateFieldGuid}'
;

# 逻辑删除字段名称的字段内容
update coz_model_chat_plate_field_content
set del_flag='2'
  ,update_by='{curUserId}'
  ,update_time=now()
  ,publish_flag=0
where plate_field_guid='{plateFieldGuid}'
;


