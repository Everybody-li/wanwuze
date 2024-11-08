-- ##Title web-查询意向预约统计-按服务名称分组统计数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询意向预约统计-按服务名称分组统计数量
-- ##CallType[QueryData]

-- ##input serveTaskGuid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
'{serveTaskGuid}' as serveTaskGuid
,t1.guid as sdPathGuid
,t1.name as sdPName
,ifnull((select count(1) from coz_serve2_serve_task_tobject_sdp where serve_task_guid='{serveTaskGuid}' and sd_path_guid=t1.guid and del_flag='0'),0) as num
from 
coz_cattype_sd_path t1
where 
t1.del_flag='0' and t1.name<>''
order by t1.norder desc