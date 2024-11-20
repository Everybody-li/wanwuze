-- ##Title web-编辑字段别名
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-编辑字段别名
-- ##CallType[ExSql]

-- ##input plateFieldGuid char[36] NOTNULL;板块字段名称guid，必填
-- ##input plateFieldAlias string[50] NOTNULL;字段别名，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @categoryGuid = null,@bizType = null,@cat_tree_code = null;

select category_guid, biz_type, cat_tree_code
into @categoryGuid,@bizType,@cat_tree_code
from
    coz_model_plate_field
where guid = '{plateFieldGuid}';

set @Flag7 = IF((exists(select 1
                        from
                            coz_model_plate_field
                        where
                              category_guid = @categoryGuid
                          and biz_type = @bizType
                          and cat_tree_code = @cat_tree_code
                          and del_flag = '0'
                          and alias = '{plateAlias}')), '0', '1')
;

update coz_category_deal_mode
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
   , publish_time= null
where @bizType = 1 and @Flag7 = '1' category_guid = @categoryGuid and publish_flag= '2';

update coz_category_supply_price
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
where @bizType = 2 category_guid = @categoryGuid and publish_flag= '2';

update coz_model_plate_field
set
    alias='{plateFieldAlias}'
  , publish_flag=0
where guid = '{plateFieldGuid}' and @Flag7 = '1';

