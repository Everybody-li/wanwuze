-- ##Title 需求-查询一个需求
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 需求-查询一个需求
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t.guid as requestGuid

from
coz_demand_request t
where 
t.category_guid='{categoryGuid}' and done_flag='0' and del_flag='0' and cancel_flag='0'
