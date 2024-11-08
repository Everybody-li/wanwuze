-- ##Title web-品类名称发布供应报价信息(一个一个发布)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-品类名称发布供应报价信息(一个一个发布)
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @canPublish =
        '{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\web\model\supplyPrice\isCanPublish_1_0_2&categoryGuid={categoryGuid}&DBC=w_a]/url}'
;
select count(1) as publishNum
from coz_category_supply_price_log
where category_guid = '{categoryGuid}'
;
delete
from coz_model_plate_field_content_formal
where biz_type = '2'
  and category_guid = '{categoryGuid}'
  and @canPublish = '1'
;
delete
from coz_model_plate_formal
where biz_type = '2'
  and category_guid = '{categoryGuid}'
  and @canPublish = '1'
;
delete
from coz_model_plate_field_formal
where biz_type = '2'
  and category_guid = '{categoryGuid}'
  and @canPublish = '1'
;
update coz_demand_request_price_plate t
    left join
    coz_demand_request_price t1
    on t.request_price_guid = t1.guid
    left join
    coz_demand_request t2
    on t1.request_guid = t2.guid
set t.status='0'
where t2.category_guid = '{categoryGuid}'
  and (t2.done_flag = '0')
;
update coz_category_supplier_model_price_plate t
    left join
    coz_category_supplier_model t1
    on t.model_guid = t1.guid
    left join
    coz_category_supplier t2
    on t1.supplier_guid = t2.guid
set t.status='0'
where t2.category_guid = '{categoryGuid}'
;
insert into coz_category_supply_price_log(guid, category_guid, cattype_guid, publish_time, create_by, create_time,
                                          update_by, update_time)
select UUID(),
       category_guid,
       cattype_guid,
       now() as publish_time,
       '{curUserId}',
       create_time,
       '{curUserId}',
       update_time
from coz_category_supply_price
where category_guid = '{categoryGuid}'
  and @canPublish = '1'
order by id desc
limit 1
;
update coz_model_plate
set publish_time=now()
  , publish_flag='2'
where publish_flag = '0'
  and biz_type = '2'
  and category_guid = '{categoryGuid}'
  and @canPublish = '1'
;
update coz_model_plate_field
set publish_time=now()
  , publish_flag='2'
where publish_flag = '0'
  and biz_type = '2'
  and category_guid = '{categoryGuid}'
  and @canPublish = '1'
;
update coz_model_plate_field_content
set publish_flag='2'
where publish_flag = '0'
  and biz_type = '2'
  and category_guid = '{categoryGuid}'
  and @canPublish = '1'
;
update coz_category_supply_price
set publish_time=now()
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
       create_time,
       '{curUserId}',
       update_time
from coz_model_plate
where del_flag = 0
  and biz_type = '2'
  and category_guid = '{categoryGuid}'
  and publish_flag = '2'
  and @canPublish = '1'
;

insert into coz_model_plate_field_formal(guid, cattype_guid, cat_tree_code, category_guid, biz_type, plate_formal_guid,
                                         demand_pf_formal_guid, name, alias, norder, source, content_source, operation,
                                         placeholder, file_template, del_flag, create_by, create_time, update_by,
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
       del_flag,
       '{curUserId}',
       create_time,
       '{curUserId}',
       update_time
from coz_model_plate_field
where del_flag = '0'
  and biz_type = '2'
  and category_guid = '{categoryGuid}'
  and publish_flag = '2'
  and @canPublish = '1'
;
insert into coz_model_plate_field_content_formal(guid, cattype_guid, cat_tree_code, category_guid, biz_type,
                                                 plate_field_formal_guid, content,norder, del_flag, create_by, create_time,
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
       t.create_time,
       '{curUserId}',
       t.update_time
from coz_model_plate_field_content t
         left join
     coz_model_plate_field t1
     on t.plate_field_guid = t1.guid
where t.del_flag = '0'
  and t1.biz_type = '2'
  and t1.category_guid = '{categoryGuid}'
  and t1.publish_flag = '2'
  and @canPublish = '1'
;

