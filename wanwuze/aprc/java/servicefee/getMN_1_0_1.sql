-- ##Title 需求-查询供方服务费定价数据-按型号名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 需求-查询供方服务费定价数据-按型号名称
-- ##CallType[QueryData]

-- ##input modelGuid char[36] NOTNULL;型号名称guid，必填


select 
t.category_guid as categoryGuid
,t.target_object as targetObject
,t.charge_type as chargeType
,t.charge_value * 100 as chargeValue
,left(t.start_date,10) as startDate
,left(t.end_date,10) as endDate
from
coz_category_service_fee_mn t
where
model_guid='{modelGuid}' and (sysdate() between start_date and end_date) and del_flag='0'
order by id desc
