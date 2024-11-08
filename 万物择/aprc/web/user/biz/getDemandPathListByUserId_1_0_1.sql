-- ##Title web-供需专员-品类权限管理
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-供需专员-品类权限管理
-- ##CallType[QueryData]

-- ##input userId string[36] NOTNULL;目标用户id(供需用户id)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t2.all_path_name as pathName
,t3.guid as sdPathGuid
,t2.guid as demandPathGuid
,case when exists(select 1 from coz_server2_sys_user_demand_path where sd_path_guid=t3.guid and demand_path_guid=t2.guid and user_id='{userId}' and del_flag='0') then '1' else '0' end as selectedFlag
from 
coz_cattype_demand_path t2
left join
coz_cattype_sd_path t3
on t2.guid=t3.demand_path_guid
where 
t2.del_flag='0' and t3.del_flag='0'
order by t2.norder desc