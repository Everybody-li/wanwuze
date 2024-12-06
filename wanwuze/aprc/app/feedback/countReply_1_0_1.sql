-- ##Title app-统计已回复未查看的数量
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-统计已回复未查看的数量
-- ##CallType[QueryData]

-- ##input userId char[36] NOTNULL;用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output count int[>=0] 1;累计反馈内容已被回复但是未查看的数量

select 
count(1) as count
from
coz_feedback t
where
t.user_id='{userId}' and reply_flag=1 and reply_content_read_flag=0 and del_flag='0'
