-- ##Title 查询供方服务费定价数据
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 查询供方服务费定价数据
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid



select 
t.category_guid as categoryGuid
,t.charge_type as chargeType
,t.charge_value as chargeValue
,t.target_object as targetObject
,t.create_time as createTimeStr
from
coz_category_service_fee_log t
where
category_guid='{categoryGuid}'and del_flag='0'
order by id desc