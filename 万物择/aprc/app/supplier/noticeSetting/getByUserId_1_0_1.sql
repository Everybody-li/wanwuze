-- ##Title app-供应-查询接收设置信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-查询接收设置信息
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
guid as noticeGuid
,receive_flag as receiveFlag
,voice_type as voiceType
from
coz_supplier_notice_setting
where 
user_id='{curUserId}' and del_flag='0'
order by id desc
;