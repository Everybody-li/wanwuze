-- ##Title app-供应-拉取(中间件推送，app拉取)个性语音通知
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-拉取(中间件推送，app拉取)个性语音通知
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
(select count(1) from coz_demand_request_match_notice where notice_setting_guid=t.guid and voice_push_flag='2' and voice_play_flag='1' and del_flag='0')
,t.voice_type as voiceType
from
coz_supplier_notice_setting t
where 
t.user_id='{curUserId}' and t.del_flag='0' and t.receive_flag='1'