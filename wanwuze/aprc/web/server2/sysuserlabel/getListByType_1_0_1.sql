-- ##Title web-查询已经添加的沟通/服务专员能力标签(除服务名称外)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询已经添加的沟通/服务专员能力标签(除服务名称外)
-- ##CallType[QueryData]

-- ##input targetUserId char[36] NOTNULL;服务对象guid，必填
-- ##input type string[1] NOTNULL;类型（1：沟通话术，2：服务话术）必填
-- ##input dataType string[1] NOTNULL;类型（1：沟通话术，2：服务话术）必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
t1.guid as userLabelGuid
,t1.data_guid as dataGuid
,t2.name as labelData
from
coz_server2_sys_user_label t1
inner join
coz_serve2_bizdict t2
on t1.data_guid=t2.guid
where (t1.user_id='{targetUserId}') and t2.del_flag='0'and t1.del_flag='0' and (t1.type='{type}' and t1.data_type='{dataType}') 
order by t2.id