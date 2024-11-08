-- ##Title 需求-保存需求消息通知
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 需求-保存需求消息通知
-- ##CallType[ExSql]

-- ##input guid char[36] NOTNULL;需求供方guid，必填
-- ##input supplyPathGuid char[36] NOTNULL;需求guid，必填
-- ##input supplyUserId char[36] NOTNULL;供方用户guid，必填
-- ##input requestGuid char[36] NOTNULL;供方用户guid，必填
-- ##input reqeustSupplyGuid string[36] NULL;供方用户guid，必填
-- ##input noticeSettingGuid string[36] NULL;供方用户guid
-- ##input recommendType char[1] NOTNULL;报价状态，必填
-- ##input voicePushFlag string[1] NOTNULL;接单语音消息提醒中间件推送时间标志，0-无需推送，1-未推送，2-已推送，必填
-- ##input voicePlayFlag string[1] NOTNULL;接单语音消息提醒供方阅读标志，供需匹配上后供方收到消息通知：0-无需通知，1-未读，2-已读，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_demand_request_match_notice(guid,supply_path_guid,user_id,request_guid,request_supply_guid,notice_setting_guid,recommend_type,voice_push_flag,voice_push_time,voice_play_flag,del_flag,create_by,create_time,update_by,update_time)
select
'{guid}'
,'{supplyPathGuid}'
,'{supplyUserId}'
,'{requestGuid}'
,'{reqeustSupplyGuid}'
,'{noticeSettingGuid}'
,'{recommendType}'
,'{voicePushFlag}'
,case when ('{voicePushFlag}'<>'0') then now() else null end
,'{voicePlayFlag}'
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()