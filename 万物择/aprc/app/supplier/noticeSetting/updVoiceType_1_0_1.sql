-- ##Title app-供应-设置个性语音
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-设置个性语音
-- ##CallType[ExSql]

-- ##input noticeGuid char[36] NOTNULL;消息通知guid，必填
-- ##input voiceType int[>=0] NOTNULL;语音消息类型：0-系统默认（跟随手机系统），1-无，2-老板，多少钱，3-有客到，必填

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_supplier_notice_setting
set voice_type='{voiceType}'
,update_by='{curUserId}'
,update_time=now()
where guid='{noticeGuid}'
;
