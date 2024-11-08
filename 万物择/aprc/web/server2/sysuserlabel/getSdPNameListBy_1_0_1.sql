-- ##Title web-查询已经添加的沟通/服务专员能力标签服务名称
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询已经添加的沟通/服务专员能力标签服务名称
-- ##CallType[QueryData]

-- ##input targetUserId char[36] NOTNULL;服务对象guid，必填
-- ##input type string[1] NOTNULL;类型（1：沟通话术，2：服务话术）必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
t1.guid as userLabelGuid
,t1.data_guid as dataGuid
,t2.name as labelData
from
coz_server2_sys_user_label t1
left join
coz_cattype_sd_path t2
on t1.data_guid=t2.guid
where (t1.user_id='{targetUserId}') and t2.del_flag='0'and t1.del_flag='0' and (t1.type='{type}') 
order by t1.id