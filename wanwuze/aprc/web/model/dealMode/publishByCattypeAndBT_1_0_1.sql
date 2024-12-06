-- ##Title web-品类名称跟随品类类型一起发布供需需求信息(一个一个发布)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-品类名称跟随品类类型一起发布供需需求信息(一个一个发布)
-- ##CallType[QueryData]

-- ##input cattypeGuid char[36] NOTNULL;品类类型guid，必填
-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

# 查询入参品类名称(非品类类型）是不是存在发布记录：0-存在，1-不存在
set @flag1 = case
                 when (exists(select 1
                              from coz_category_deal_mode_log
                              where category_guid = '{categoryGuid}'
                                and '{categoryGuid}' <> '{cattypeGuid}')) then '0'
                 else '1' end
;

# 删除品类名称的字段内容数据-草稿表
delete
from coz_model_plate_field_content
where biz_type = '1'
  and category_guid = '{categoryGuid}'
  and @flag1 = '1'
;

# 删除品类名称的板块数据-草稿表
delete
from coz_model_plate
where biz_type = '1'
  and category_guid = '{categoryGuid}'
  and @flag1 = '1'
;

# 删除品类名称的板块字段数据-草稿表
delete
from coz_model_plate_field
where biz_type = '1'
  and category_guid = '{categoryGuid}'
  and @flag1 = '1'
;

# 删除品类名称的板块字段内容数据-正式表
delete
from coz_model_plate_field_content_formal
where biz_type = '1'
  and category_guid = '{categoryGuid}'
  and @flag1 = '1'
;

# 删除品类名称的板块数据-正式表
delete
from coz_model_plate_formal
where biz_type = '1'
  and category_guid = '{categoryGuid}'
  and @flag1 = '1'
;

# 删除品类名称的板块数据-正式表
delete
from coz_model_plate_field_formal
where biz_type = '1'
  and category_guid = '{categoryGuid}'
  and @flag1 = '1'
;

# 新增品类名称的供需发布日志
insert into coz_category_deal_mode_log(guid, category_guid, cattype_guid, publish_time, create_by, create_time,
                                       update_by, update_time)
select UUID(),
       category_guid,
       cattype_guid,
       now() as publish_time,
       '{curUserId}',
       create_time,
       '{curUserId}',
       update_time
from coz_category_deal_mode
where category_guid = '{categoryGuid}'
  and @flag1 = '1'
order by id desc
limit 1
;

# 复制所属品类类型的板块数据
insert into coz_model_plate(guid, cattype_guid, cat_tree_code, category_guid, biz_type, fixed_data_code, alias, norder,
                            publish_flag, del_flag, create_by, create_time, update_by, update_time, temp_guid)
select UUID()
     , '{cattypeGuid}'
     , cat_tree_code
     , '{categoryGuid}'
     , biz_type
     , fixed_data_code
     , alias
     , norder
     , '0'
     , '2'
     , '-1'
     , now()
     , '-1'
     , now()
     , guid
from coz_model_plate
where category_guid = '{cattypeGuid}'
  and cattype_guid = '{cattypeGuid}'
  and (biz_type = '1')
  and del_flag = '0'
  and '{categoryGuid}' <> '{cattypeGuid}'
  and @flag1 = '1'
;

# 复制所属品类类型的板块字段数据-草稿表
insert into coz_model_plate_field(guid, cattype_guid, cat_tree_code, category_guid, biz_type, plate_guid,
                                  demand_pf_guid, name, alias, norder, publish_flag, source, content_source, operation,
                                  placeholder, file_template, file_template_display,del_flag, create_by, create_time, update_by, update_time,
                                  temp_guid)
select UUID()
     , '{cattypeGuid}'
     , cat_tree_code
     , '{categoryGuid}'
     , biz_type
     , plate_guid
     , demand_pf_guid
     , name
     , alias
     , norder
     , '0'
     , source
     , content_source
     , operation
     , placeholder
     , file_template
     , file_template_display
     , '2'
     , '-1'
     , now()
     , '-1'
     , now()
     , guid
from coz_model_plate_field
where category_guid = '{cattypeGuid}'
  and cattype_guid = '{cattypeGuid}'
  and (biz_type = '1')
  and del_flag = '0'
  and '{categoryGuid}' <> '{cattypeGuid}'
  and @flag1 = '1'
;


# 复制所属品类类型的板块字段内容数据-草稿表
insert into coz_model_plate_field_content(guid, cattype_guid, cat_tree_code, category_guid, biz_type, plate_field_guid,
                                          content, publish_flag, del_flag, create_by, create_time, update_by,
                                          update_time, temp_guid)
select UUID()
     , '{cattypeGuid}'
     , cat_tree_code
     , '{categoryGuid}'
     , biz_type
     , plate_field_guid
     , content
     , '0'
     , '2'
     , '-1'
     , now()
     , '-1'
     , now()
     , guid
from coz_model_plate_field_content
where category_guid = '{cattypeGuid}'
  and cattype_guid = '{cattypeGuid}'
  and (biz_type = '1')
  and del_flag = '0'
  and '{categoryGuid}' <> '{cattypeGuid}'
  and @flag1 = '1'
;

# 复制所属品类类型的板块数据-正式表
insert into coz_model_plate_formal(guid, cattype_guid, cat_tree_code, category_guid, biz_type, fixed_data_code, alias,
                                   norder, del_flag, create_by, create_time, update_by, update_time, temp_guid)
select UUID(),
       '{cattypeGuid}',
       cat_tree_code,
       '{categoryGuid}',
       biz_type,
       fixed_data_code,
       alias,
       norder,
       '2',
       '-1',
       now(),
       '-1',
       now(),
       guid
from coz_model_plate
where category_guid = '{cattypeGuid}'
  and cattype_guid = '{cattypeGuid}'
  and (biz_type = '1')
  and del_flag = '0'
  and '{categoryGuid}' <> '{cattypeGuid}'
  and @flag1 = '1'
;


# 复制所属品类类型的板块字段数据-正式表
insert into coz_model_plate_field_formal(guid, cattype_guid, cat_tree_code, category_guid, biz_type, plate_formal_guid,
                                         demand_pf_formal_guid, name, alias, norder, source, content_source, operation,
                                         placeholder, file_template, del_flag, create_by, create_time, update_by,
                                         update_time, temp_guid)
select UUID(),
       '{cattypeGuid}',
       cat_tree_code,
       '{categoryGuid}',
       biz_type,
       plate_guid,
       demand_pf_guid,
       name,
       alias,
       norder,
       source,
       content_source,
       operation,
       placeholder,
       file_template,
       '2',
       '-1',
       now(),
       '-1',
       now(),
       guid
from coz_model_plate_field
where category_guid = '{cattypeGuid}'
  and cattype_guid = '{cattypeGuid}'
  and (biz_type = '1')
  and del_flag = '0'
  and '{categoryGuid}' <> '{cattypeGuid}'
  and @flag1 = '1'
;


# 复制所属品类类型的需方的板块字段内容数据-正式表
insert into coz_model_plate_field_content_formal(guid, cattype_guid, cat_tree_code, category_guid, biz_type,
                                                 plate_field_formal_guid, content, norder, del_flag, create_by,
                                                 create_time,
                                                 update_by, update_time, temp_guid)
select UUID(),
       '{cattypeGuid}',
       t.cat_tree_code,
       '{categoryGuid}',
       t.biz_type,
       t.plate_field_guid,
       t.content,
       t.id,
       '2',
       '-1',
       now(),
       '-1',
       now(),
       t.guid
from coz_model_plate_field_content t
         left join coz_model_plate_field t1 on t.plate_field_guid = t1.guid
where t.del_flag = '0'
  and t1.biz_type = '1'
  and t1.category_guid = '{cattypeGuid}'
  and t1.cattype_guid = '{cattypeGuid}'
  and '{categoryGuid}' <> '{cattypeGuid}'
  and @flag1 = '1'
;

# 复制所属品类类型的供方的板块字段内容数据-正式表(重复复制了一份需方的字段内容数据，并标记为供方)
insert into coz_model_plate_field_content_formal(guid, cattype_guid, cat_tree_code, category_guid, biz_type,
                                                 plate_field_formal_guid, content, norder, del_flag, create_by,
                                                 create_time,
                                                 update_by, update_time, temp_guid)
select UUID(),
       '{cattypeGuid}',
       t2.cat_tree_code,
       '{categoryGuid}',
       t2.biz_type,
       t2.guid,
       t.content,
       t.id,
       '2',
       '-1',
       now(),
       '-1',
       now(),
       t.guid
from coz_model_plate_field_content t
         left join coz_model_plate_field t1 on t.plate_field_guid = t1.guid
         left join coz_model_plate_field t2
                   on t1.name = t2.name and t2.publish_flag = 2 and t2.category_guid = t1.category_guid and
                      t2.cat_tree_code = 'supply'
where t.del_flag = '0'
  and t1.biz_type = '1'
  and t1.category_guid = '{cattypeGuid}'
  and t1.cattype_guid = '{cattypeGuid}'
  and '{categoryGuid}' <> '{cattypeGuid}'
  and t2.guid is not null
  and t2.biz_type = '1'
  and @flag1 = '1'
;
select 1 as publishNum;
