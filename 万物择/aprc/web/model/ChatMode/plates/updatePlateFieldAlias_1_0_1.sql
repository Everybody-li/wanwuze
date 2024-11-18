-- ##Title web-编辑字段别名
-- 使用方:WebAPP
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-编辑字段别名
-- ##CallType[ExSql]

-- ##input plateFieldGuid char[36] NOTNULL;板块字段名称guid，必填
-- ##input plateFieldAlias string[50] NOTNULL;字段别名，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @categoryGuid = null,@cat_tree_code = null;

select category_guid, cat_tree_code
into @categoryGuid,@cat_tree_code
from
    coz_model_chat_plate_field
where guid = '{plateFieldGuid}';

set @Flag7 = IF((exists(select 1
                        from
                            coz_model_chat_plate_field
                        where
                              category_guid = @categoryGuid
                          and cat_tree_code = @cat_tree_code
                          and del_flag = '0'
                          and alias = '{plateAlias}')), '0', '1')
;

update coz_category_chat_mode
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
   , publish_time= null
where  @Flag7 = '1' and category_guid = @categoryGuid;


update coz_model_chat_plate_field
set
    alias='{plateFieldAlias}'
  , publish_flag=0
where guid = '{plateFieldGuid}' and @Flag7 = '1';

