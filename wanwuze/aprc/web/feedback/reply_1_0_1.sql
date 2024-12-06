-- ##Title web-回复反馈
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-回复反馈
-- ##CallType[ExSql]

-- ##input feedbackGuid char[36] NOTNULL;反馈guid，必填
-- ##input replyContent string[500] NOTNULL;回复的内容，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_feedback
set reply_flag=1
,reply_time=now()
,reply_content_read_flag=0
,reply_content_read_time=now()
,reply_content='{replyContent}'
,update_by='{curUserId}'
,update_time=now()
where guid='{feedbackGuid}'
;
