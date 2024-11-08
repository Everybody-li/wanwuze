-- ##Title 沟通模式根据品类guid查询生效的招聘信息guid列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 沟通模式根据品类guid查询生效的招聘信息guid列表
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
t1.guid as recruitGuid
,t1.user_id as userId
from  
coz_chat_recruit t1
inner join
sys_app_user t2
on t1.user_id=t2.guid
where 
t1.category_guid='{categoryGuid}' and t1.user_id<>'{curUserId}' and t1.status='1' and t2.status='0' and t1.del_flag='0' and t2.del_flag='0'

