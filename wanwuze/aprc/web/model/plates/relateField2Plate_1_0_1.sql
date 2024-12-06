-- ##Title web-字段名称关联板块名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-字段名称关联板块名称
-- ##CallType[ExSql]

-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid，必填
-- ##input plateGuid char[36] NOTNULL;板块类型guid，必填
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
where @bizType = 1  and category_guid = @categoryGuid and publish_flag= '2';

update coz_category_supply_price
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
where @bizType = 2   and category_guid = @categoryGuid and publish_flag= '2';

update coz_model_plate_field 
set plate_guid='{plateGuid}'
,publish_flag='0'
where guid='{plateFieldGuid}'
