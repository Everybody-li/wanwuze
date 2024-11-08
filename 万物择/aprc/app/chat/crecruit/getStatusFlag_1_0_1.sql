-- ##Title app-查询招聘信息详情生效失效标志
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询招聘信息详情生效失效标志
-- ##CallType[QueryData]

-- ##input recruitGuid char[36] NOTNULL;招聘信息guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
status
from
coz_chat_recruit t1
where 
t1.guid='{recruitGuid}'
