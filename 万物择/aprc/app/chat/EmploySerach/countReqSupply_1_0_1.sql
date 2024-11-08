-- ##Title app-应聘-应聘进展管理-投递信息管理-投递记录管理-查询投递数量(app暂时忽略)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05 
-- ##Describe 表名:coz_chat_supply_request_demand
-- ##CallType[QueryData]

-- ##input deRequestGuid char[36] NOTNULL;应聘需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output reqSupplyCount int[>=0] 0;当前需求已经进行应聘投递的招聘方数量

select count(1) as reqSupplyCount
from coz_chat_supply_request_demand
where del_flag = '0'
  and status = '1'
  and send_resume_flag = '1'
  and de_request_guid = '{deRequestGuid}';
