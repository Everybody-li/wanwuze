-- ##Title app-应聘-应聘进展管理-受邀信息接收-系统推荐管理-删除
-- ##Author 卢文彪
-- ##CreateTime 2023-09-14
-- ##CallType[ExSql]

-- ##input requestSupplyGuid char[36] NOTNULL;应聘需求应聘信息guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @derequestguid=(select de_request_guid from coz_chat_supply_request_demand where guid='{requestSupplyGuid}')
;
update coz_chat_supply_request_detail
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where de_request_guid=@derequestguid
;
update coz_chat_supply_request_demand
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{requestSupplyGuid}'
;

