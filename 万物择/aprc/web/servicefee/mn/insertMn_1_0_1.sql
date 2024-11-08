-- ##Title web-新增服务定价-按型号名称_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新增服务定价-按型号名称_1_0_1
-- ##CallType[ExSql]

-- ##input categoryGuid string[50] NOTNULL;品类名称guid，必填
-- ##input modelGuid string[50] NOTNULL;型号guid，必填
-- ##input targetObject string[50] NOTNULL;收取对象(前端固定传demand)，必填
-- ##input chargeType string[50] NOTNULL;收取方式(前端-按比例=1，按金额=2)，必填
-- ##input chargeValue int[>=0] NOTNULL;收取数值(整数)，必填
-- ##input startDate string[50] NOTNULL;起始时间(前端默认选中最近一次终止时间，最近一次终止时间根据接口获取，最近一次终止时间及以前日期不可选)，必填
-- ##input endDate string[10] NOTNULL;终止时间(前端判断必须大于起始时间)，必填
-- ##input remark string[200] NOTNULL;更新说明，必填
-- ##input remarkImgs string[200] NOTNULL;更新说明图片(前端图片上传成功后才能提交表单)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_category_service_fee_mn(guid,category_guid,model_guid,charge_type,charge_value,target_object,start_date,end_date,remark,remark_imgs,del_flag,create_by,create_time,update_by,update_time)
select
*
from
(
select
uuid() as guid
,'{categoryGuid}' as ou_collect_guid
,'{modelGuid}' as org_valid_guid
,'{chargeType}' as chargeType
,'{chargeValue}' as chargeValue
,'{targetObject}' as targetObject
,'{startDate}' as start_date
,'{endDate}' as end_date
,'{remark}' as remark
,'{remarkImgs}' as remarkImgs
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_category_supplier_model
where guid='{modelGuid}'
) t
where
('{startDate}'<='{endDate}') and 
('{startDate}'>=ifnull((select end_date from coz_category_service_fee_mn where model_guid='{modelGuid}' and del_flag='0' order by end_date limit 1),'2000-01-01')) 
;