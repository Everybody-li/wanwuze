-- ##Title app-品类交易状态埋点-根据需求guid获取品类模式
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2023-09-21
-- ##Describe 获取品类模式
-- ##CallType[QueryData]

-- ##input requestGuid char[36] NOTNULL;需求guid，必填

-- ##output catMode enum[1,2,3] 1;品类模式:1-沟通模式,2-交易模式,3-审批模式

select t1.category_mode as catMode
from coz_demand_request t1
where t1.guid = '{requestGuid}';