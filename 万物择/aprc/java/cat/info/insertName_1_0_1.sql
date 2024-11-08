-- ##Title 新增品类信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 新增品类信息
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input categoryName string[500] NOTNULL;品类名称，必填
-- ##input secenGuid char[36] NOTNULL;末级场景guid，必填
-- ##input mode string[1] NOTNULL;品类模式（1：沟通模式，2：交易模式），必填
-- ##input loginCode string[2] NULL;品类所属登录系统code，必填
-- ##input cattypeGuid char[36] NOTNULL;品类类型guid，必填
-- ##input cattypeName string[500] NOTNULL;品类类型名称，必填

set @dealRulePublish=(select case when exists(select 1 from coz_category_deal_rule_log where category_guid='{cattypeGuid}') then'1' else '0' end )
;
set @deadlineguid=uuid(),@dealruleguid=uuid()
;
set @dealModePublish=(select case when exists(select 1 from coz_category_deal_mode_log where category_guid='{cattypeGuid}' and cattype_guid='{cattypeGuid}' ) then'1' else '0' end )
;
set @supplypricePublish=(select case when exists(select 1 from coz_category_supply_price_log where category_guid='{cattypeGuid}' and cattype_guid='{cattypeGuid}' ) then'1' else '0' end )
;
INSERT INTO coz_category_info 
(guid,code,name,alias,mode,login_code,cattype_guid,cattype_name,active,del_flag,create_by,create_time,update_by,update_time) 
select 
'{categoryGuid}' as guid
,'' as code
,'{categoryName}' as name
,'' as alias
,'{mode}' as mode
,'{loginCode}' as loginCode
,'{cattypeGuid}' as cattypeguid
,'{cattypeName}' as cattypename
,1 as active
,'0' as del_flag
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
;
INSERT INTO coz_category_deal_rule
(guid,cattype_guid,category_guid,price_mode,serve_fee_flag,del_flag,create_by,create_time,update_by,update_time,publish_flag,publish_time) 
select 
@dealruleguid as guid
,'{cattypeGuid}' as cattypeguid
,'{categoryGuid}' as categoryGuid
,price_mode
,serve_fee_flag
,'0' as del_flag
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
,'2'  as publish_flag
,now() as publish_time
from
coz_category_deal_rule_log
where 
category_guid='{cattypeGuid}' and '{mode}'='2' and del_flag='0' and @dealRulePublish='1'
order by id desc
limit 1
;
INSERT INTO coz_category_deal_rule_log
(guid,deal_rule_guid,category_guid,price_mode,serve_fee_flag,del_flag,create_by,create_time,update_by,update_time,publish_time) 
select
uuid() 
,@dealruleguid as guid
,'{categoryGuid}' as categoryGuid
,price_mode
,serve_fee_flag
,'0' as del_flag
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
,now() as publish_time
from
coz_category_deal_rule_log
where 
category_guid='{cattypeGuid}'  and '{mode}'='2' and del_flag='0' and @dealRulePublish='1'
order by id desc
limit 1
;
INSERT INTO coz_category_deal_rule
(guid,cattype_guid,category_guid,del_flag,create_by,create_time,update_by,update_time)
select 
uuid() as guid
,'{cattypeGuid}' as cattypeguid
,'{categoryGuid}' as categoryGuid
,'0' as del_flag
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
from
coz_guidance_criterion
where
'{mode}'='2' and @dealRulePublish='0'
order by id desc
limit 1
;
INSERT INTO coz_category_deal_mode
(category_guid,cattype_guid,del_flag,create_by,create_time,update_by,update_time,publish_time) 
select 
'{categoryGuid}' as categoryGuid
,'{cattypeGuid}' as cattypeguid
,'0' as del_flag
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
,now() as publish_time
from
coz_category_deal_mode_log
where 
category_guid='{cattypeGuid}' and cattype_guid='{cattypeGuid}' and '{mode}'='2'  and @dealModePublish='1'
order by id desc
limit 1
;
INSERT INTO coz_category_deal_mode_log
(guid,category_guid,cattype_guid,publish_time,create_by,create_time,update_by,update_time) 
select 
uuid()
,'{categoryGuid}' as categoryGuid
,'{cattypeGuid}' as cattypeguid
,now() as publish_time
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
from
coz_category_deal_mode_log
where 
category_guid='{cattypeGuid}' and cattype_guid='{cattypeGuid}' and '{mode}'='2'  and @dealModePublish='1'
order by id desc
limit 1
;
INSERT INTO coz_category_deal_mode
(category_guid,cattype_guid,del_flag,create_by,create_time,update_by,update_time) 
select 
'{categoryGuid}' as categoryGuid
,'{cattypeGuid}' as cattypeguid
,'0' as del_flag
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
from
coz_guidance_criterion
where 
'{mode}'='2'  and @dealModePublish='0'
order by id desc
limit 1
;
insert into coz_model_plate(guid,cattype_guid,cat_tree_code,category_guid,biz_type,fixed_data_code,alias,norder,publish_flag,del_flag,create_by,create_time,update_by,update_time,temp_guid)
select
UUID()
,'{cattypeGuid}'
,cat_tree_code
,'{categoryGuid}'
,biz_type
,fixed_data_code
,alias
,norder
,0
,'2'
,'1'
,now()
,'1'
,now()
,guid
from
coz_model_plate
where category_guid='{cattypeGuid}' and cattype_guid='{cattypeGuid}' and '{mode}'='2' and ((biz_type=1 and @dealModePublish='1' ) or (biz_type=2 and @supplypricePublish='1' )) and del_flag='0'
;
insert into coz_model_plate_field(guid,cattype_guid,cat_tree_code,category_guid,biz_type,plate_guid,demand_pf_guid,name,alias,norder,publish_flag,source,content_source,operation,placeholder,file_template,del_flag,create_by,create_time,update_by,update_time,temp_guid)
select
UUID()
,'{cattypeGuid}'
,cat_tree_code
,'{categoryGuid}'
,biz_type
,plate_guid
,demand_pf_guid
,name
,alias
,norder
,0
,source
,content_source
,operation
,placeholder
,file_template
,'2'
,'1'
,now()
,'1'
,now()
,guid
from
coz_model_plate_field
where category_guid='{cattypeGuid}' and cattype_guid='{cattypeGuid}' and '{mode}'='2' and ((biz_type=1 and @dealModePublish='1' ) or (biz_type=2 and @supplypricePublish='1' )) and del_flag='0'
;
insert into coz_model_plate_field_content(guid,cattype_guid,cat_tree_code,category_guid,biz_type,plate_field_guid,content,publish_flag,del_flag,create_by,create_time,update_by,update_time,temp_guid)
select
UUID()
,'{cattypeGuid}'
,cat_tree_code
,'{categoryGuid}'
,biz_type
,plate_field_guid
,content
,'0'
,'2'
,'1'
,now()
,'1'
,now()
,guid
from
coz_model_plate_field_content
where category_guid='{cattypeGuid}' and cattype_guid='{cattypeGuid}' and '{mode}'='2' and ((biz_type=1 and @dealModePublish='1' ) or (biz_type=2 and @supplypricePublish='1' )) and del_flag='0'
;
insert into coz_model_plate_formal(guid,cattype_guid,cat_tree_code,category_guid,biz_type,fixed_data_code,alias,norder,del_flag,create_by,create_time,update_by,update_time,temp_guid)
select
UUID()
,'{cattypeGuid}'
,cat_tree_code
,'{categoryGuid}'
,biz_type
,fixed_data_code
,alias
,norder
,'2'
,'1'
,now()
,'1'
,now()
,guid
from
coz_model_plate
where category_guid='{cattypeGuid}' and cattype_guid='{cattypeGuid}' and '{mode}'='2' and ((biz_type=1 and @dealModePublish='1' ) or (biz_type=2 and @supplypricePublish='1' )) and del_flag='0'
;
insert into coz_model_plate_field_formal(guid,cattype_guid,cat_tree_code,category_guid,biz_type,plate_formal_guid,demand_pf_formal_guid,name,alias,norder,source,content_source,operation,placeholder,file_template,del_flag,create_by,create_time,update_by,update_time,temp_guid)
select
UUID()
,'{cattypeGuid}'
,cat_tree_code
,'{categoryGuid}'
,biz_type
,plate_guid
,demand_pf_guid
,name
,alias
,norder
,source
,content_source
,operation
,placeholder
,file_template
,'2'
,'1'
,now()
,'1'
,now()
,guid
from
coz_model_plate_field
where category_guid='{cattypeGuid}' and cattype_guid='{cattypeGuid}' and '{mode}'='2' and ((biz_type=1 and @dealModePublish='1' ) or (biz_type=2 and @supplypricePublish='1' )) and del_flag='0'
;
insert into coz_model_plate_field_content_formal(guid,cattype_guid,cat_tree_code,category_guid,biz_type,plate_field_formal_guid,content,del_flag,create_by,create_time,update_by,update_time,temp_guid)
select
UUID()
,'{cattypeGuid}'
,cat_tree_code
,'{categoryGuid}'
,biz_type
,plate_field_guid
,content
,'2'
,'1'
,now()
,'1'
,now()
,guid
from
coz_model_plate_field_content
where category_guid='{cattypeGuid}' and cattype_guid='{cattypeGuid}' and '{mode}'='2' and ((biz_type=1 and @dealModePublish='1' ) or (biz_type=2 and @supplypricePublish='1' )) and del_flag='0'
;
INSERT INTO coz_category_supply_price
(category_guid,cattype_guid,del_flag,create_by,create_time,update_by,update_time,publish_time) 
select 
'{categoryGuid}' as categoryGuid
,'{cattypeGuid}' as cattype_guid
,'0' as del_flag
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
,now() as publish_time
from
coz_category_supply_price_log
where '{mode}'='2' and category_guid='{cattypeGuid}' and cattype_guid='{cattypeGuid}' and @supplypricePublish='1'
order by id desc
limit 1
;
INSERT INTO coz_category_supply_price_log
(guid,category_guid,cattype_guid,publish_time,create_by,create_time,update_by,update_time) 
select 
uuid()
,'{categoryGuid}' as categoryGuid
,'{cattypeGuid}' as cattype_guid
,now() as publish_time
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
from
coz_category_supply_price_log
where '{mode}'='2' and category_guid='{cattypeGuid}' and cattype_guid='{cattypeGuid}' and @supplypricePublish='1'
order by id desc
limit 1
;
INSERT INTO coz_category_supply_price
(category_guid,cattype_guid,del_flag,create_by,create_time,update_by,update_time) 
select 
'{categoryGuid}' as categoryGuid
,'{cattypeGuid}' as cattype_guid
,'0' as del_flag
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
from
coz_guidance_criterion
where '{mode}'='2' and @supplypricePublish='0'
order by id desc
limit 1
;
insert into coz_category_service_fee_log(guid,category_guid,charge_value,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{categoryGuid}' as categoryGuid
,charge_value
,'0' as del_flag
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
from
coz_category_service_fee
where '{mode}'='2' and category_guid='{cattypeGuid}' and del_flag='0'
order by id desc
limit 1
;
INSERT INTO coz_category_service_fee
(category_guid,charge_type,charge_value,target_object,del_flag,create_by,create_time,update_by,update_time) 
select 
'{categoryGuid}' as categoryGuid
,charge_type
,charge_value
,target_object
,'0' as del_flag
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
from
coz_category_service_fee
where '{mode}'='2' and category_guid='{cattypeGuid}' and del_flag='0'
order by id desc
limit 1
;
insert into coz_category_deal_deadline (guid,cattype_guid,category_guid,day,del_flag,create_by,create_time,update_by,update_time)
select
@deadlineguid as guid
,'{cattypeGuid}' as cattype_guid
,'{categoryGuid}' as categoryGuid
,day
,'0' as del_flag
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
from
coz_category_deal_deadline
where '{mode}'='2' and category_guid='{cattypeGuid}' and del_flag='0' and day>0
order by id desc
limit 1
;
insert into coz_category_deal_deadline_log (guid,deadline_guid,category_guid,day,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,@deadlineguid as deadline_guid
,'{categoryGuid}' as categoryGuid
,day
,'0' as del_flag
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
from
coz_category_deal_deadline
where '{mode}'='2' and category_guid='{cattypeGuid}' and del_flag='0' and day>0
order by id desc
limit 1
;
insert into coz_category_deal_deadline (guid,cattype_guid,category_guid,day,del_flag,create_by,create_time,update_by,update_time)
select
@deadlineguid as guid
,'{cattypeGuid}' as cattype_guid
,'{categoryGuid}' as categoryGuid
,day
,'0' as del_flag
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
from
coz_category_deal_deadline
where '{mode}'='2' and category_guid='{cattypeGuid}' and del_flag='0' and day=0
order by id desc
limit 1
;