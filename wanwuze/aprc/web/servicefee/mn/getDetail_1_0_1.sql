-- ##Title web-查询供方型号服务定价详情-按型号名称_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询供方型号服务定价详情-按型号名称_1_0_1
-- ##CallType[QueryData]

-- ##input serviceFeeMnGuid char[36] NOTNULL;型号名称定价guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
t.guid as serviceFeeMnGuid
,t.category_guid as categoryGuid
,t.model_guid as modelGuid
,case when (t.target_object='demand') then '需方' when (t.target_object='supply') then '供方' else '暂未设置' end as targetObject
,case when (t.charge_type='1') then '按比例' when (t.charge_type='2') then '按数值' else '其他' end as chargeType
,case when (t.charge_type='1') then concat(t.charge_value,'%') when (t.charge_type='2') then concat('￥',t.charge_value) else '其他' end as chargeValue
,left(t.create_time,16) as createTime
,left(t.start_date,10) as startDate
,left(t.end_date,10) as endDate
,t.remark
,t.remark_imgs as remarkFiles
from
coz_category_service_fee_mn t
where
t.guid='{serviceFeeMnGuid}'