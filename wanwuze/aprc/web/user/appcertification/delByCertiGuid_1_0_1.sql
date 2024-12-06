-- ##Title web-删除实名认证信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-删除实名认证信息
-- ##CallType[ExSql]

-- ##input certiGuid char[36] NOTNULL;实名认证guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id


update coz_chat_friend
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{certiGuid}'
;
