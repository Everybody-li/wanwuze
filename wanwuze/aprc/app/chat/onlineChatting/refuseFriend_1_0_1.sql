-- ##Title app-拒绝好友申请
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-申请在线沟通
-- ##CallType[ExSql]

-- ##input applyGuid char[36] NOTNULL;申请guid，必填
update coz_chat_friend_apply
set status=2
,update_time=now()
,react_time=now()
where guid='{applyGuid}'
;

