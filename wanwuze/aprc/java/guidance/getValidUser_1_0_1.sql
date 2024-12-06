-- ##Title 订单-查询用户的服务用户
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 订单-查询用户的服务用户
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;被引导用户id，必填

-- ##output guserRecordLogGuid char[36] 引导记录日志主键guid;引导记录日志主键guid
-- ##output guserRecordGuid char[36] 引导记录主键guid;引导记录主键guid
-- ##output guideUserId char[36] 引导专员用户id;引导专员用户id

select 
t1.guid as guserRecordLogGuid
,t1.guser_record_guid as guserRecordGuid
,t1.guided_user_id as guidedUserId
from 
coz_guidance_user_record_log t1
where 
t1.guided_user_id='{curUserId}' and t1.take_back_flag=0
order by t1.id desc
limit 1