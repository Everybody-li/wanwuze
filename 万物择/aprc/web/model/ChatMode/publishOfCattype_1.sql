-- ##Title web-发布供需需求信息
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-发布供需需求信息
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @canPublish =
        '{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\web\model\ChatMode\isCanPublish_1&categoryGuid={categoryGuid}&DBC=w_a]/url}';

set @IsNeedUpdDeResumeStstus0 =
        '{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\web\model\ChatMode\IsNeedUpdDeResumeStstus0_1&categoryGuid={categoryGuid}&DBC=w_a]/url}';
delete from coz_model_chat_plate_field_content_formal where @canPublish = '1' and category_guid = '{categoryGuid}'
;
delete from coz_model_chat_plate_formal where @canPublish = '1' and category_guid = '{categoryGuid}'
;
delete from coz_model_chat_plate_field_formal where @canPublish = '1' and category_guid = '{categoryGuid}'
;
insert into
    coz_category_chat_mode_log( guid, category_guid, cattype_guid, publish_time, create_by, create_time, update_by
                              , update_time )
select
    UUID()
  , category_guid
  , cattype_guid
  , now() as publish_time
  , '{curUserId}'
  , create_time
  , '{curUserId}'
  , update_time
from
    coz_category_chat_mode
where @canPublish = '1' and category_guid = '{categoryGuid}'
order by id desc
limit 1
;

update coz_model_chat_plate
set
    publish_time=now()
  , publish_flag='2'
  , update_time = now()
  , update_by   = '{curUserId}'
where
      @canPublish = '1'
  and category_guid = '{categoryGuid}'
  and publish_flag = '0'
;
update coz_model_chat_plate_field
set
    publish_time=now()
  , publish_flag='2'
  , update_time = now()
  , update_by   = '{curUserId}'
where
      @canPublish = '1'
  and category_guid = '{categoryGuid}'
  and publish_flag = '0'
;
update coz_model_chat_plate_field_content
set
    publish_flag='2'
  , update_time = now()
  , update_by   = '{curUserId}'
where
      @canPublish = '1'
  and category_guid = '{categoryGuid}'
  and publish_flag = '0'
;
update coz_category_chat_mode
set
    publish_time=now()
  , publish_flag = '2'
  , update_time = now()
  , update_by = '{curUserId}'
where @canPublish = '1' and category_guid = '{categoryGuid}' and publish_flag = '0'
;


insert into
    coz_model_chat_plate_formal
    ( guid, cattype_guid, cat_tree_code, category_guid, fixed_data_code, alias, norder, del_flag, create_by, create_time
    , update_by, update_time )
select
    guid
  , cattype_guid
  , cat_tree_code
  , category_guid
  , fixed_data_code
  , alias
  , norder
  , del_flag
  , '{curUserId}'
  , now()
  , '{curUserId}'
  , now()
from
    coz_model_chat_plate t
where
      @canPublish = '1'
  and category_guid = '{categoryGuid}'
  and publish_flag = '2'
  and del_flag = 0
  and not exists(select 1 from coz_model_chat_plate_formal where guid = t.guid)
;

insert into
    coz_model_chat_plate_field_formal( guid, cattype_guid, cat_tree_code, category_guid, plate_formal_guid
                                     , demand_pf_formal_guid, name, alias, norder, source, content_source, operation
                                     , placeholder, file_template, file_template_display, del_flag, create_by
                                     , create_time, update_by, update_time )
select
    guid
  , cattype_guid
  , cat_tree_code
  , category_guid
  , plate_guid
  , demand_pf_guid
  , name
  , alias
  , norder
  , source
  , content_source
  , operation
  , placeholder
  , file_template
  , file_template_display
  , del_flag
  , '{curUserId}'
  , now()
  , '{curUserId}'
  , now()
from
    coz_model_chat_plate_field t
where
      @canPublish = '1'
  and category_guid = '{categoryGuid}'
  and publish_flag = '2'
  and del_flag = '0'
  and not exists(select 1 from coz_model_chat_plate_field_formal where guid = t.guid)
;
insert into
    coz_model_chat_plate_field_content_formal( guid, cattype_guid, cat_tree_code, category_guid, plate_field_formal_guid
                                             , content, norder, del_flag, create_by, create_time, update_by
                                             , update_time )
select
    t.guid
  , t.cattype_guid
  , t.cat_tree_code
  , t.category_guid
  , t.plate_field_guid
  , t.content
  , t.id
  , t.del_flag
  , '{curUserId}'
  , now()
  , '{curUserId}'
  , now()
from
    coz_model_chat_plate_field_content t
    left join
        coz_model_chat_plate_field     t1
            on t.plate_field_guid = t1.guid
where
      @canPublish = '1'
  and t1.category_guid = '{categoryGuid}'
  and t1.publish_flag = '2'
  and t.del_flag = '0'
  and not exists(select 1 from coz_model_chat_plate_field_content_formal where guid = t.guid)
;
insert into
    coz_model_chat_plate_field_content_formal( guid, cattype_guid, cat_tree_code, category_guid, plate_field_formal_guid
                                             , content, norder, del_flag, create_by, create_time, update_by
                                             , update_time )
select
    uuid()
  , t2.cattype_guid
  , t2.cat_tree_code
  , t2.category_guid
  , t2.guid
  , t.content
  , t.id
  , t.del_flag
  , '{curUserId}'
  , now()
  , '{curUserId}'
  , now()
from
    coz_model_chat_plate_field_content t
    left join
        coz_model_chat_plate_field     t1
            on t.plate_field_guid = t1.guid
    left join
        coz_model_chat_plate_field     t2
            on t1.name = t2.name and t2.publish_flag = 2 and t2.category_guid = t1.category_guid and
               t2.cat_tree_code = 'supply'
where
      @canPublish = '1'
  and t1.category_guid = '{categoryGuid}'
  and t.del_flag = '0'
  and t1.publish_flag = '2'
  and t2.guid is not null
;

--  web-更新沟通模式-供需需求信息-将需方个人入库信息改为失效
update coz_chat_demand_resume
set
    status      = '0'
  , status_time = now()
  , update_by   = '{curUserId}'
  , update_time = now()
where @canPublish = '1' and @IsNeedUpdDeResumeStstus0 = '1' and status = '1';
update coz_chat_demand_resume_plate
set
    status      = '0'
  , status_time = now()
where @canPublish = '1' and @IsNeedUpdDeResumeStstus0 = '1' and status = '1';

select count(1) as publishNum from coz_category_chat_mode_log where category_guid = '{categoryGuid}'
