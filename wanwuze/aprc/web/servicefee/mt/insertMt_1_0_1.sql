-- ##Title web-新增服务定价-按型号类型_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新增服务定价-按型号类型_1_0_1
-- ##CallType[ExSql]

-- ##input categoryGuid string[50] NOTNULL;品类名称guid，必填
-- ##input targetObject string[50] NOTNULL;收取对象(前端固定传demand)，必填
-- ##input chargeType string[50] NOTNULL;收取方式(前端-按比例=1)，必填
-- ##input mchargeValue int[>=0] NOTNULL;收取数值(整数)，必填
-- ##input nomchargeValue int[>=0] NOTNULL;收取数值(整数)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

delete from coz_category_service_fee_mt where category_guid='{categoryGuid}'
;
insert into coz_category_service_fee_mt_log(guid,category_guid,mcharge_value,nomcharge_value,charge_type,target_object,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{categoryGuid}' as categoryGuid
,'{mchargeValue}' as mchargeValue
,'{nomchargeValue}' as nomchargeValue
,'{chargeType}' as chargeType
,'{targetObject}' as targetObject
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
;
insert into coz_category_service_fee_mt(guid,category_guid,mcharge_value,nomcharge_value,charge_type,target_object,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{categoryGuid}' as categoryGuid
,'{mchargeValue}' as mchargeValue
,'{nomchargeValue}' as nomchargeValue
,'{chargeType}' as chargeType
,'{targetObject}' as targetObject
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
;