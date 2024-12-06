-- ##Title app-品类交易状态埋点-根据需求guid获取品类模式
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2023-09-21
-- ##Describe 获取品类模式
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填

-- ##output catMode enum[1,2,3] 1;品类模式:1-沟通模式,2-交易模式,3-审批模式

select t1.category_mode as catMode
from coz_demand_request t1
         inner join coz_order t2 on t1.guid = t2.request_guid
where t2.guid = '{orderGuid}'
  and t2.pay_status = '2'
  and t2.del_flag = '0';