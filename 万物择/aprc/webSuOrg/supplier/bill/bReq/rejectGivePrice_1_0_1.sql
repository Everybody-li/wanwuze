-- ##Title app-供应-拒绝报价
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 后端修改表，将报价状态改为拒绝报价，表数据的报价状态为未报价时修改，否则不做任何处理
-- ##CallType[ExSql]

-- ##input requestSupplyGuid char[36] NOTNULL;需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_demand_request_supply
set price_status='2'
,price_time=now()
,update_by='{curUserId}'
,update_time=now()
where
guid='{requestSupplyGuid}' and price_status='1'
;