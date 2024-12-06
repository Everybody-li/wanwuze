-- ##Title web-意向服务查看
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-意向服务查看
-- ##CallType[QueryData]

-- ##input serveTaskTobjectGuid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t2.name as sdPName
from 
coz_serve2_serve_task_tobject_sdp t1
inner join
coz_cattype_sd_path t2
on t1.sd_path_guid=t2.guid
where t1.serve_task_tobject_guid='{serveTaskTobjectGuid}' and t1.del_flag='0' and t2.del_flag='0'
order by t2.id desc