-- ##Title app-采购-统计已报价供方数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-统计已报价供方数量
-- ##CallType[QueryData]

-- ##input requestGuid char[36] NOTNULL;需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select count(1) as supplyCount from coz_demand_request_supply where del_flag='0' and price_status='3' and request_guid='{requestGuid}' and (de_read_sudel_flag='0' or de_read_sudel_flag='1')