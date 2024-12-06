-- ##Title web-品类类型发布供需需求信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-品类类型发布供需需求信息
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select count(1) as publishNum from coz_category_supply_price_log where category_guid='{categoryGuid}'
;
update coz_category_buy_qualification_user_plate t
set status='0'
where exists(select 1 from coz_category_buy_qualification_user a right join (select category_guid,max(id) as MID from coz_category_buy_qualification_user group by category_guid) b on a.id=b.MID where a.guid=t.qualification_user_guid and a.category_guid='{categoryGuid}') and status='1'
;
update coz_category_buy_qualification_user t
right join
(select category_guid,max(id) as MID from coz_category_buy_qualification_user group by category_guid) t1
on t.id=t1.MID
set t.status='0'
where t.category_guid='{categoryGuid}' and t.status='1'
;
delete from coz_model_plate_field_content_formal where biz_type='4' and category_guid='{categoryGuid}'
;
delete from coz_model_plate_formal where biz_type='4' and category_guid='{categoryGuid}'
;
delete from coz_model_plate_field_formal where biz_type='4' and category_guid='{categoryGuid}'
;
insert into coz_category_buy_qualification_log(guid,category_guid,publish_time,create_by,create_time)
select
uuid(),category_guid,now() as publish_time,'{curUserId}' as create_by,now() as create_time
from 
coz_category_buy_qualification
where category_guid='{categoryGuid}'
order by id desc
limit 1
;
update coz_model_plate
set publish_time=now()
,publish_flag='2'
where
publish_flag='0' and biz_type='4' and category_guid='{categoryGuid}'
;
update coz_model_plate_field
set publish_time=now()
,publish_flag='2'
where
publish_flag='0' and biz_type='4' and category_guid='{categoryGuid}'
;
update coz_model_plate_field_content
set publish_flag='2'
where
publish_flag='0' and biz_type='4' and category_guid='{categoryGuid}'
;
update coz_category_buy_qualification
set publish_time=now()
where category_guid='{categoryGuid}'
;
insert into coz_model_plate_formal (guid,cattype_guid,cat_tree_code,category_guid,biz_type,fixed_data_code,alias,norder,del_flag,create_by,create_time,update_by,update_time)
select
guid,cattype_guid,cat_tree_code,category_guid,biz_type,fixed_data_code,alias,norder,del_flag,'{curUserId}',create_time,'{curUserId}',update_time
from
coz_model_plate
where
del_flag='0' and biz_type='4' and category_guid='{categoryGuid}' and publish_flag='2'
;

insert into coz_model_plate_field_formal(guid,cattype_guid,cat_tree_code,category_guid,biz_type,plate_formal_guid,name,alias,norder,source,content_source,operation,placeholder,file_template,del_flag,create_by,create_time,update_by,update_time)
select
guid,cattype_guid,cat_tree_code,category_guid,biz_type,plate_guid,name,alias,norder,source,content_source,operation,placeholder,file_template,del_flag,'{curUserId}',create_time,'{curUserId}',update_time
from
coz_model_plate_field 
where
del_flag='0' and biz_type='4' and category_guid='{categoryGuid}' and publish_flag='2'
;
insert into coz_model_plate_field_content_formal(guid,cattype_guid,cat_tree_code,category_guid,biz_type,plate_field_formal_guid,content,del_flag,create_by,create_time,update_by,update_time)
select
t.guid,t.cattype_guid,t.cat_tree_code,t.category_guid,t.biz_type,t.plate_field_guid,t.content,t.del_flag,'{curUserId}',t.create_time,'{curUserId}',t.update_time
from
coz_model_plate_field_content t
left join
coz_model_plate_field t1
on t.plate_field_guid=t1.guid
where 
t.del_flag='0' and t1.biz_type='4' and t1.category_guid='{categoryGuid}' and t1.publish_flag='2'
;
