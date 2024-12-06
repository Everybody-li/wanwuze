-- ##Title web-发布指派规则
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-发布指派规则
-- ##CallType[ExSql]

-- ##input categoryGuid string[36] NOTNULL;指派规则guid，必填

-- ##input curUserId string[36] MOTNULL;登录用户id，必填

select count(1) as publishNum from coz_category_model_supply_assign_log where category_guid ='{categoryGuid}'
;
insert into coz_category_model_supply_assign_log(guid,category_guid,cattype_guid,rule_type,publish_time,create_by,create_time)
select
UUID()
,category_guid
,cattype_guid
,rule_type
,now()
,'1'
,now()
from
coz_category_model_supply_assign
where 
category_guid ='{categoryGuid}'
;
update coz_category_model_supply_assign
set publish_flag='2'
,publish_time=now()
where category_guid ='{categoryGuid}'
