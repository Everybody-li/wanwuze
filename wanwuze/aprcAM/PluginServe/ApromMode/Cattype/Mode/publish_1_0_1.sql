-- ##Title 插件端-web后台-审批模式-通用配置/配置管理-供需需求信息管理-发布逻辑-发布
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe 新增或修改
-- ##Describe 如果当前品类已经是发布的状态，则直接返回”已发布，无需操作“
-- ##Describe 如果是第一次发布，则返回提示信息”发布成功“，否则返回提示信息：”发布成功且覆盖原来版本，刷新后可使用“
-- ##Describe 发布逻辑：
-- ##Describe 1、将供需需求板块等相关配置草稿表未逻辑删除的的数据复制到对应的正式表，正式表的每个表的guid，都用对应草稿表的guid
-- ##Describe 2、复制后将供需需求信息主表t1表的发布状态改为已发布，并新增发布记录t2表
-- ##Describe 表名：coz_model_am_aprom_mode t1,coz_model_am_aprom_mode_log t2
-- ##Describe 表名：coz_model_am_aprom_plate t3,coz_model_am_aprom_plate_field t4,coz_model_am_aprom_plate_field_settings t5, coz_model_am_aprom_plate_field_content t6,
-- ##Describe 表名：coz_model_am_aprom_plate_formal t7,coz_model_am_aprom_plate_field_formal t8,coz_model_am_aprom_plate_field_settings_formal t9，coz_model_am_aprom_plate_field_content_formal t10
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类类型guid/品类名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output okFlag enum[0,1] 1;操作结果：0-发布失败，1-发布成功
-- ##output msg string[100] 操作提示语;操作提示语

set @publishFlag = (select case
                               when exists(select 1
                                           from coz_category_am_aprom_mode
                                           where category_guid = '{categoryGuid}'
                                             and del_flag = '0'
                                             and publish_flag = '2') then '1'
                               else '0' end)
;
set @publishHisFlag = (select case
                                  when exists(select 1
                                              from coz_category_am_aprom_mode_log
                                              where category_guid = '{categoryGuid}') then '1'
                                  else '0' end)
;
delete
from coz_model_am_clone_guid
where cattype_guid = '{categoryGuid}'
  and biz_type = '1'
  and @publishFlag = '0'
;
delete
from coz_model_am_aprom_plate_field_content_formal
where category_guid = '{categoryGuid}'
  and @publishFlag = '0'
;
delete
from coz_model_am_aprom_plate_formal
where category_guid = '{categoryGuid}'
  and @publishFlag = '0'
;
delete
from coz_model_am_aprom_plate_field_formal
where category_guid = '{categoryGuid}'
  and @publishFlag = '0'
;
delete
from coz_model_am_aprom_plate_field_settings_formal
where category_guid = '{categoryGuid}'
  and @publishFlag = '0'
;
insert into coz_category_am_aprom_mode_log
    (guid, category_guid, cattype_guid, create_by, create_time)
select uuid(),
       category_guid,
       cattype_guid,
       '{curUserId}',
       now()
from coz_category_am_aprom_mode
where category_guid = '{categoryGuid}'
  and @publishFlag = '0'
order by id desc
limit 1
;
update coz_category_am_aprom_mode
set publish_flag='2'
  , publish_time=now()
  , publish_by='{curUserId}'
where category_guid = '{categoryGuid}'
  and @publishFlag = '0'
;
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{categoryGuid}', '1', guid, uuid(), create_by, now()
from coz_model_am_aprom_plate
where category_guid = '{categoryGuid}'
  and category_guid = cattype_guid
  and del_flag = '0'
  and @publishFlag = '0'
;
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{categoryGuid}', '1', guid, uuid(), create_by, now()
from coz_model_am_aprom_plate_field
where category_guid = '{categoryGuid}'
  and category_guid = cattype_guid
  and del_flag = '0'
  and @publishFlag = '0'
;
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{categoryGuid}', '1', guid, uuid(), create_by, now()
from coz_model_am_aprom_plate_field_settings
where category_guid = '{categoryGuid}'
  and category_guid = cattype_guid
  and del_flag = '0'
  and @publishFlag = '0'
;
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{categoryGuid}', '1', guid, uuid(), create_by, now()
from coz_model_am_aprom_plate_field_content
where category_guid = '{categoryGuid}'
  and category_guid = cattype_guid
  and del_flag = '0'
  and @publishFlag = '0'
;
insert into coz_model_am_aprom_plate_formal
( guid
, cattype_guid
, category_guid
, fixed_data_code
, alias
, norder
, version
, del_flag
, create_by
, create_time
, update_by
, update_time)
select guid
     , cattype_guid
     , category_guid
     , fixed_data_code
     , alias
     , norder
     , 1
     , del_flag
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_model_am_aprom_plate t
where del_flag = '0'
  and category_guid = '{categoryGuid}'
  and @publishFlag = '0'
  and not exists(select 1 from coz_model_am_aprom_plate_formal where guid = t.guid)
;
insert into coz_model_am_aprom_plate_field_formal
( guid
, cattype_guid
, category_guid
, plate_guid
, name
, alias
, source
, content_fixed_data_guid
, norder
, version
, del_flag
, create_by
, create_time)
select guid
     , cattype_guid
     , category_guid
     , plate_guid
     , name
     , alias
     , source
     , content_fixed_data_guid
     , norder
     , 1
     , del_flag
     , '{curUserId}'
     , now()
from coz_model_am_aprom_plate_field t
where del_flag = '0'
  and category_guid = '{categoryGuid}'
  and @publishFlag = '0'
  and not exists(select 1 from coz_model_am_aprom_plate_field_formal where guid = t.guid)
;
insert into coz_model_am_aprom_plate_field_content_formal
( guid
, cattype_guid
, category_guid
, plate_field_guid
, name
, relate_field_guid
, norder
, version
, del_flag
, create_by
, create_time)
select guid
     , cattype_guid
     , category_guid
     , plate_field_guid
     , name
     , relate_field_guid
     , norder
     , 1
     , del_flag
     , '{curUserId}'
     , now()
from coz_model_am_aprom_plate_field_content t
where del_flag = '0'
  and category_guid = '{categoryGuid}'
  and @publishFlag = '0'
  and not exists(select 1 from coz_model_am_aprom_plate_field_content_formal where guid = t.guid)
;
insert into coz_model_am_aprom_plate_field_settings_formal
( guid
, cattype_guid
, category_guid
, plate_field_guid
, cat_tree_code
, content_source
, operation
, placeholder
, file_template
, norder
, del_flag
, create_by
, create_time
, update_by
, update_time)
select guid
     , cattype_guid
     , category_guid
     , plate_field_guid
     , cat_tree_code
     , content_source
     , operation
     , placeholder
     , file_template
     , norder
     , del_flag
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_model_am_aprom_plate_field_settings t
where del_flag = '0'
  and category_guid = '{categoryGuid}'
  and @publishFlag = '0'
  and not exists(select 1 from coz_model_am_aprom_plate_field_settings_formal where guid = t.guid)
;
select case when (@publishFlag = '0') then '1' else '0' end as okFlag
     , case
           when (@publishFlag = '1') then '已发布，无需操作'
           when (@publishHisFlag = '1') then '发布成功且覆盖原来版本，刷新后可使用'
           else '发布成功' end                                  as msg
;










