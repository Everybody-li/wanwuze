-- ##Title app-采购-查询订单退款接收列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-查询订单退款接收列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input sdPathGuid char[36] NULL;采购供应路径关联guid，必填


select 
count(1) as refundSupAcceptCount
from 
coz_order_judge t
left join 
coz_order t1 
on t.order_guid=t1.guid 
where 
t1.demand_user_id='{curUserId}' and t.result<>'3' and t1.accept_status='1' and t.biz_type='2' and t1.sd_path_guid='{sdPathGuid}'

