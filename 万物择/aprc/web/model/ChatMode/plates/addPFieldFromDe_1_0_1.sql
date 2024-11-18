-- ##Title web-供应需求信息添加库字段名称配置
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-供应需求信息添加库字段名称配置
-- ##CallType[ExSql]

-- ##input plateFieldGuid char[36] NOTNULL;需方字段名称guid，必填
-- ##input fixedDataCode string[100] NULL;固化字段名称code，必填
-- ##input plateFieldName string[100] NOTNULL;固化字段名称，必填
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
where   category_guid = '{categoryGuid}';

update coz_category_chat_mode
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
where  category_guid = '{categoryGuid}';


insert into
    coz_model_chat_plate_field
    ( guid, cattype_guid, cat_tree_code, category_guid,  plate_guid, demand_pf_guid, name, alias, norder
    , publish_flag, publish_time, source, content_source, operation, placeholder, file_template, del_flag, create_by
    , create_time, update_by, update_time )
select *
from
    (
        select
            uuid()
          , cattype_guid
          , 'supply'                                                                  as cat_tree_code
          , category_guid
          , ''
          , '{plateFieldGuid}'                                                        as plateFieldGuid
          , case when ('{fixedDataCode}' = '') then name else '{fixedDataCode}' end   as name
          , case when ('{plateFieldName}' = '') then name else '{plateFieldName}' end as alias
          , norder
          , publish_flag
          , publish_time
          , source
          , '0'                                                                       as content_source
          , '0'                                                                       as operation
          , placeholder
          , file_template
          , 0                                                                         as del_flag
          , '{curUserId}'                                                             as create_by
          , now()                                                                     as create_time
          , '{curUserId}'                                                             as update_by
          , now()                                                                     as update_time
        from
            coz_model_chat_plate_field
        where
            guid = '{plateFieldGuid}'
    ) t
where
    not exists(select 1
               from
                   coz_model_chat_plate_field
               where
                     cat_tree_code = 'supply'
                 and category_guid = t.category_guid
                 and name = t.name
                 and alias = t.alias
                 and del_flag = '0')
