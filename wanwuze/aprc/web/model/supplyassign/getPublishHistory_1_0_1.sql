-- ##Title web-查询发布记录
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询发布记录
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
left(t.publish_time,16) as publishTime
from
coz_category_model_supply_assign_log t
where 
category_guid='{categoryGuid}' 
order by publish_time desc
;

