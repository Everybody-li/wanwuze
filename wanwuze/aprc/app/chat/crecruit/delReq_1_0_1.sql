-- ##Title app-用户未进行投递时删除用户需求
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-用户未进行投递时删除用户需求
-- ##CallType[ExSql]

-- ##input deRequestGuid char[36] NOTNULL;应聘需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_chat_demand_request_detail
set del_flag='2'
,update_time=now()
,update_by='{curUserId}'
where de_request_guid='{deRequestGuid}'
;
update coz_chat_demand_request
set del_flag='2'
,update_time=now()
,update_by='{curUserId}'
where guid='{deRequestGuid}'
;
