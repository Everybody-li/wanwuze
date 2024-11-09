-- ##Title web-品类类型发布供需需求信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-品类类型发布供需需求信息
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @canPublish =
        '{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\web\model\dealMode\isCanPublish_1_0_2&categoryGuid={categoryGuid}&DBC=w_a]/url}'
;
select count(1) as publishNum
from coz_category_deal_mode_log
where category_guid = '{categoryGuid}'
;
delete
from coz_model_plate_field_content_formal
where biz_type = '1'
  and category_guid = '{categoryGuid}'
;
delete
from coz_model_plate_formal
where biz_type = '1'
  and category_guid = '{categoryGuid}'
;
delete
from coz_model_plate_field_formal
where biz_type = '1'
  and category_guid = '{categoryGuid}'
;
update coz_demand_request_plate t
    left join
    coz_demand_request t1
    on t.request_guid = t1.guid
set t.status='0'
  , t1.status0_read_flag=case when (t1.status0_read_flag = '0') then '1' else t1.status0_read_flag end
where t1.category_guid = '{categoryGuid}'
  and (t1.done_flag = '0')
  and not exists(select 1 from coz_demand_request_price where request_guid = t1.guid)
;
update coz_category_supplier_bill t
    left join
    coz_category_supplier t1
    on t.supplier_guid = t1.guid
set t.status='0'
where t1.category_guid = '{categoryGuid}'
;
update coz_category_supplier_model_plate t
    left join
    coz_category_supplier_model t1
    on t.model_guid = t1.guid
    left join
    coz_category_supplier t2
    on t1.supplier_guid = t2.guid
set t.status='0'
where t2.category_guid = '{categoryGuid}'
;
update coz_category_supplier_model_plate t
    left join
    coz_category_supplier_model t1
    on t.model_guid = t1.guid
    left join
    coz_category_supplier t2
    on t1.supplier_guid = t2.guid
set t.status='0'
where t2.category_guid = '{categoryGuid}'
;
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
  and @canPublish = '1'
order by id desc
limit 1
;
update coz_model_plate
set publish_time=now()
  , publish_flag='2'
,update_time = now()
,update_by = '{curUserId}'
where publish_flag = '0'
  and biz_type = '1'
  and category_guid = '{categoryGuid}'
  and @canPublish = '1'
;
update coz_model_plate_field
set publish_time=now()
  , publish_flag='2'
,update_time = now()
,update_by = '{curUserId}'
where publish_flag = '0'
  and biz_type = '1'
  and category_guid = '{categoryGuid}'
  and @canPublish = '1'
;
update coz_model_plate_field_content
set publish_flag='2'
,update_time = now()
,update_by = '{curUserId}'
where publish_flag = '0'
  and biz_type = '1'
  and category_guid = '{categoryGuid}'
  and @canPublish = '1'
;
update coz_category_deal_mode
set publish_time=now()
,update_time = now()
,update_by = '{curUserId}'
where category_guid = '{categoryGuid}'
  and @canPublish = '1'
;
insert into coz_model_plate_formal (guid, cattype_guid, cat_tree_code, category_guid, biz_type, fixed_data_code, alias,
                                    norder, del_flag, create_by, create_time, update_by, update_time)
select guid,
       cattype_guid,
       cat_tree_code,
       category_guid,
       biz_type,
       fixed_data_code,
       alias,
       norder,
       del_flag,
       '{curUserId}',
       now(),
       '{curUserId}',
       now()
from coz_model_plate t
where del_flag = 0
  and biz_type = '1'
  and category_guid = '{categoryGuid}'
  and publish_flag = '2'
  and @canPublish = '1'
  and not exists(select 1 from coz_model_plate_formal where guid = t.guid)
;

insert into coz_model_plate_field_formal(guid, cattype_guid, cat_tree_code, category_guid, biz_type, plate_formal_guid,
                                         demand_pf_formal_guid, name, alias, norder, source, content_source, operation,
                                         placeholder, file_template, file_template_display, del_flag, create_by, create_time, update_by,
                                         update_time)
select guid,
       cattype_guid,
       cat_tree_code,
       category_guid,
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
       file_template_display,
       del_flag,
       '{curUserId}',
       now(),
       '{curUserId}',
       now()
    from coz_model_plate_field t
where del_flag = '0'
  and biz_type = '1'
  and category_guid = '{categoryGuid}'
  and publish_flag = '2'
  and @canPublish = '1'
  and not exists(select 1 from coz_model_plate_field_formal where guid = t.guid)
;
insert into coz_model_plate_field_content_formal(guid, cattype_guid, cat_tree_code, category_guid, biz_type,
                                                 plate_field_formal_guid, content, norder,del_flag, create_by, create_time,
                                                 update_by, update_time)
select t.guid,
       t.cattype_guid,
       t.cat_tree_code,
       t.category_guid,
       t.biz_type,
       t.plate_field_guid,
       t.content,
       t.id,
       t.del_flag,
       '{curUserId}',
       now(),
       '{curUserId}',
       now()
from coz_model_plate_field_content t
         left join
     coz_model_plate_field t1
     on t.plate_field_guid = t1.guid
where t.del_flag = '0'
  and t1.biz_type = '1'
  and t1.category_guid = '{categoryGuid}'
  and t1.publish_flag = '2'
  and @canPublish = '1'
  and not exists(select 1 from coz_model_plate_field_content_formal where guid = t.guid)
;
insert into coz_model_plate_field_content_formal(guid, cattype_guid, cat_tree_code, category_guid, biz_type,
                                                 plate_field_formal_guid, content,norder, del_flag, create_by, create_time,
                                                 update_by, update_time)
select uuid(),
       t2.cattype_guid,
       t2.cat_tree_code,
       t2.category_guid,
       t2.biz_type,
       t2.guid,
       t.content,
       t.id,
       t.del_flag,
       '{curUserId}',
       now(),
       '{curUserId}',
       now()
from coz_model_plate_field_content t
         left join
     coz_model_plate_field t1
     on t.plate_field_guid = t1.guid
         left join
     coz_model_plate_field t2
     on t1.name = t2.name and t2.publish_flag = 2 and t2.category_guid = t1.category_guid and
        t2.cat_tree_code = 'supply'
where t.del_flag = '0'
  and t1.biz_type = '1'
  and t1.category_guid = '{categoryGuid}'
  and t1.publish_flag = '2'
  and t2.guid is not null
  and t2.biz_type = '1'
  and @canPublish = '1'
;
