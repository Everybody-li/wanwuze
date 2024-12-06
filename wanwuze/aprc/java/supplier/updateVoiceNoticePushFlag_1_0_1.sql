-- ##Title 需求-更新个性语音通知推状态_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 需求-更新个性语音通知推状态_1_0_1
-- ##CallType[ExSql]

-- ##input reqeustSupplyGuid char[36] NOTNULL;需求供方guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_demand_request_match_notice
set voice_push_flag='2'
,voice_push_time=now()
,voice_play_flag='2'
,update_by='{curUserId}'
,update_time=now()
where request_supply_guid='{reqeustSupplyGuid}' and voice_push_flag='2' and voice_play_flag='1'