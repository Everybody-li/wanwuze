-- ##Title web-查询需求验收通过管理的机构数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询需求验收通过管理的机构数量
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
count(1) as acceptSupplyCount
from
(
select
distinct t1.supply_user_id
from 
coz_order t1
where 
t1.del_flag='0' and t1.category_guid='{categoryGuid}' and t1.accept_status='1'
)t