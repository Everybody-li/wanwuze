-- ##Title web-查询某一型号最大终止时间-按型号名称_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询某一型号最大终止时间-按型号名称_1_0_1
-- ##CallType[QueryData]

-- ##input modelGuid string[36] NOTNULL;型号guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

select ifnull((
select 
left(max(DATE_ADD(t.end_date,INTERVAL 1 day)),10)
from
coz_category_service_fee_mn t
where 
model_guid='{modelGuid}'),left(now(),10)) as maxEndDate
