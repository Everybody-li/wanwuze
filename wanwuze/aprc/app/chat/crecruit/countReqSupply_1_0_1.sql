-- ##Title app-查询用户已经应聘投递的用人单位(招聘方)数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询用户已经应聘投递的用人单位(招聘方)数量
-- ##CallType[QueryData]

-- ##input deRequestGuid char[36] NOTNULL;应聘需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select count(1) as reqSupplyCount from coz_chat_demand_request_supply where del_flag='0' and status='1' and send_resume_flag='1' and de_request_guid='{deRequestGuid}'