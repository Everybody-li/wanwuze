-- ##Title 需求-查询需求消息通知
-- ##Author 卢文彪
-- ##CreateTime 2023-10-08
-- ##Describe 需求-查询需求消息通知
-- ##CallType[QueryData]

-- ##input requestGuid char[36] NOTNULL;需求guid
-- ##input supplyUserId char[36] NOTNULL;供方用户guid
-- ##input requestSupplyGuid char[36] NULL;供方用户guid
-- ##input modelGuid char[36] NULL;供方用户guid
-- ##input curUserId char[36] NOTNULL;登录用户id

-- ##output guid char[36] ;通知guid


select guid
from coz_demand_request_match_notice
where request_guid = '{requestGuid}'
  and user_id = '{supplyUserId}'
  and request_supply_guid = '{requestSupplyGuid}'
  and model_guid = '{modelGuid}'
  and del_flag = '0';