-- ##Title app-根据订单查询子订单guid
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-根据订单查询子订单guid
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NULL;订单guid
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t1.guid as chOrderGuid
from  
coz_order t1
where 
t1.parent_guid='{orderGuid}' and t1.del_flag='0'