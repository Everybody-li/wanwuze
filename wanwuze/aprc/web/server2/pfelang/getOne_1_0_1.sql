-- ##Title web-查询沟通/服务话术信息详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询沟通/服务话术信息详情
-- ##CallType[QueryData]

-- ##input pfelangGuid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t1.guid as pfelangGuid
,t1.file_name as fileName
,t1.file_value as fileValue
,left(t1.create_time,16) as createTime
from 
coz_serve2_pfelang t1
where t1.guid='{pfelangGuid}'