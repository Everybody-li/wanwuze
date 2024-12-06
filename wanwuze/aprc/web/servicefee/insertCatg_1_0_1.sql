-- ##Title web-设置定价-按品类
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-设置定价-按品类
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input chargeType string[1] NOTNULL;收费类型(1：按比例，2-按数值)，必填
-- ##input chargeValue decimal[>=0] NOTNULL;收取比例，必填
-- ##input targetObject string[10] NOTNULL;收取对象(demand-需方，supply-供方)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

delete from coz_category_service_fee where category_guid='{categoryGuid}'
;
insert into coz_category_service_fee_log(guid,category_guid,charge_type,charge_value,target_object,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{categoryGuid}' as category_guid
,'{chargeType}' as charge_type
,{chargeValue} as chargeValue
,'{targetObject}' as target_object
,'0' as del_flag
,'-1' as create_by
,now() as create_time
,'-1' as update_by
,now() as update_time
;
insert into coz_category_service_fee (category_guid,charge_type,charge_value,target_object,description,del_flag,create_by,create_time,update_by,update_time)
select
'{categoryGuid}' as category_guid
,'{chargeType}' as charge_type
,{chargeValue} as chargeValue
,'{targetObject}' as target_object
,'' as description
,'0' as del_flag
,'-1' as create_by
,now() as create_time
,'-1' as update_by
,now() as update_time
;