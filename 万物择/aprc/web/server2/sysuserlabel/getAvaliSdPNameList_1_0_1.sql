-- ##Title web-查询可选择的服务名称列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询可选择的服务名称列表
-- ##CallType[QueryData]

-- ##input targetUserId char[36] NOTNULL;服务对象guid，必填
-- ##input type string[1] NOTNULL;类型（1：沟通话术，2：服务话术）必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
t2.guid as dataGuid
,t2.name as labelData
,case when exists(select 1 from coz_server2_sys_user_label where data_guid=t2.guid and del_flag='0' and user_id='{targetUserId}') then '1' else '0' end as selectedFlag
from
coz_cattype_sd_path t2
where  t2.del_flag='0' and t2.name<>''
order by t2.norder