-- ##Title app-权限用户信息的权限详情-上半部分
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-权限用户信息的权限详情-上半部分

-- ##input curUserId string[36] NOTNULL;用户id，必填
-- ##input createTime char[10] NOTNULL;领取日期(格式：0000-00-00)，必填

select
'{createTime}' as createTime
,(
select 
count(1) as collectNum
from 
coz_guidance_user_record_log
where user_id='{curUserId}' and left(create_time,10)='{createTime}' 
) as collectNum
,(
select 
count(1) as validNum
from 
coz_guidance_user_record
where user_id='{curUserId}' and left(create_time,10)='{createTime}'  and take_back_flag='0'
) as validNum

