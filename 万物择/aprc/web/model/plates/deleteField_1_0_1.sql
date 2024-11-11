-- ##Title web-删除字段名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除字段名称
-- ##CallType[ExSql]

-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


set @categoryGuid = null,@bizType = null;

select category_guid, biz_type
into @categoryGuid,@bizType
from
    coz_model_plate_field
where guid = '{plateFieldGuid}';

update coz_category_deal_mode
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
where @bizType = 1 and category_guid = @categoryGuid;

update coz_category_supply_price
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
where @bizType = 2  and category_guid = @categoryGuid;


# 逻辑删除字段名称
update coz_model_plate_field
set del_flag='2'
  ,update_by='{curUserId}'
  ,update_time=now()
  ,publish_flag=0
where guid='{plateFieldGuid}';


# 逻辑删除供方的字段名称(关联自需方的字段)
update coz_model_plate_field
set del_flag='2'
  ,update_by='{curUserId}'
  ,update_time=now()
  ,publish_flag=0
where demand_pf_guid='{plateFieldGuid}'
;

# 逻辑删除字段名称的字段内容
update coz_model_plate_field_content
set del_flag='2'
  ,update_by='{curUserId}'
  ,update_time=now()
  ,publish_flag=0
where plate_field_guid='{plateFieldGuid}'
;


