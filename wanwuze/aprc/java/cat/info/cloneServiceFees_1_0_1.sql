-- ##Title 接口4：新增服务定价相关信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 接口4：新增服务定价相关信息
-- ##CallType[ExSql]

-- ##input cattypeGuid char[36] NOTNULL;这个字段值是品类类型Guid，必填
-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input chargeType char[1] NOTNULL;收费类型：1-按比例，2-按数值
-- ##input chargeValue string[10] NOTNULL;收取数值
-- ##input targetObject string[20] NOTNULL;收取对象：0:暂未设置,demand-需方，supply-供方
-- ##input createTimeStr string[19] NOTNULL;创建时间，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


insert into coz_category_service_fee (category_guid,charge_type,charge_value,target_object, create_by, create_time,
                                      update_by, update_time)
values ( '{categoryGuid}'
	,'{chargeType}'
	,'{chargeValue}' 
	,  'demand'
       ,  '{curUserId}'
       ,  now()
       ,  '{curUserId}'
       ,  now())
;

insert into coz_category_service_fee_log(guid,category_guid,charge_type,charge_value,target_object,del_flag,create_by,create_time,update_by,update_time)
values (
UUID() 
,'{categoryGuid}'
,'{chargeType}'
,'{chargeValue}' 
,'{targetObject}' 
,'0' 
,'1'
,now()
,'1' 
,now() 
)
;