-- ##Title web-沟通应用信息-查看用户交互信息列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-沟通应用信息-查看用户交互信息列表
-- ##CallType[QueryData]

-- ##input objectGuid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select t5.name as serverName,t2.create_time as createTime,'沟通专员' as source
from
coz_serve2_commu_task t1
inner join
coz_serve2_commu_task_tobject t2
on t1.guid=t2.commu_task_guid
inner join
coz_cattype_sd_path t5
on t1.sd_path_guid=t5.guid
where t2.object_guid='{objectGuid}'
union all
select t5.name as serverName,t4.create_time as createTime,'服务专员' as source
from
coz_serve2_serve_task_tobject t3
inner join
coz_serve2_serve_task_tobject_sdp t4
on t3.serve_task_guid=t4.serve_task_guid
inner join
coz_cattype_sd_path t5
on t4.sd_path_guid=t5.guid
where t3.object_guid='{objectGuid}'
