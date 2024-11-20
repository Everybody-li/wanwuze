-- ##Title web-删除板块名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除板块名称
-- ##CallType[ExSql]

-- ##input plateGuid char[36] NOTNULL;板块guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填



set @categoryGuid = null,@bizType = null;

select category_guid, biz_type
into @categoryGuid,@bizType
from
    coz_model_plate
where guid = '{plateGuid}';

update coz_category_deal_mode
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
where @bizType = 1 category_guid = @categoryGuid and publish_flag= '2';

update coz_category_supply_price
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
where @bizType = 2  category_guid = @categoryGuid and publish_flag= '2';


update coz_model_plate_field_content 
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where plate_field_guid in (select guid from coz_model_plate_field where plate_guid='{plateGuid}')
;
update coz_model_plate_field 
set del_flag='2'
,publish_flag=0
,update_by='{curUserId}'
,update_time=now()
where plate_guid='{plateGuid}'
;
update coz_model_plate 
set del_flag='2'
,publish_flag=0
,update_by='{curUserId}'
,update_time=now()
where guid='{plateGuid}'