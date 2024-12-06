-- ##Title web-查询需求支付标志
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询需求支付标志
-- ##CallType[QueryData]

-- ##input demandRequestGuid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
t1.guid as demandRequestGuid
,case when (t1.done_flag='1' and t1.done_flag_xjsuser_read_flag='1') then '1' else '0' end as popupFlag
from 
coz_demand_request t1
where 
t1.guid='{demandRequestGuid}'