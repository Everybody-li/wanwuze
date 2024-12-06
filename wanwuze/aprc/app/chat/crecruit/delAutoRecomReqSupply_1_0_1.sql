-- ##Title app-招聘方-删除系统推荐的需求
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-招聘方-删除系统推荐的需求
-- ##CallType[ExSql]

-- ##input requestSupplyGuid char[36] NOTNULL;应聘需求招聘信息guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @derequestguid=(select de_request_guid from coz_chat_demand_request_supply where guid='{requestSupplyGuid}')
;
update coz_chat_demand_request_detail
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where de_request_guid=@derequestguid
;
update coz_chat_demand_request_supply
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{requestSupplyGuid}'
;

