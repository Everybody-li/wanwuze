-- ##Title app-供应-更新语音通知为已播放
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-更新语音通知为已播放
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_demand_request_match_notice
set voice_play_flag='2'
,voice_play_time=now()
,update_by='{curUserId}'
,update_time=now()
where user_id='{curUserId}' and voice_push_flag='2' and voice_play_flag='1'