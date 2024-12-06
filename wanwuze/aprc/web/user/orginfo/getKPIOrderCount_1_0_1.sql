-- ##Title web-供应机构用户-查询供应机构采购订单验收通过数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-供应机构用户-查询供应机构采购订单验收通过数量
-- ##CallType[QueryData]


-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orgUserId char[36] NOTNULL;供应机构用户id，必填


select
count(1) as totalOrderNum
from
coz_order t1
where 
t1.supply_user_id='{orgUserId}' and t1.del_flag='0' and t1.accept_status='1'

