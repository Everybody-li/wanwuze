-- ##Title web-查询意向预约统计-有接受服务名称的总数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询意向预约统计-有接受服务名称的总数量
-- ##CallType[QueryData]

-- ##input serveTaskGuid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
count(1) as totalCount
from 
coz_serve2_serve_task_tobject_sdp t1
where t1.serve_task_guid='{serveTaskGuid}' and del_flag='0'