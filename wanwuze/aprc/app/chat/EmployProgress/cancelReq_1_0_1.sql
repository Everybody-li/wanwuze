-- ##Title app-招聘-招聘进展管理-邀约信息管理-邀约等待信息-取消需求
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-招聘-取消邀约等待的需求
-- ##CallType[ExSql]

-- ##input deRequestGuid char[36] NOTNULL;招聘需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_chat_supply_request
set cancel_flag='2'
,cancel_time=now()
,update_time=now()
,update_by='{curUserId}'
where guid='{deRequestGuid}'
;
