-- ##Title web-供需专员-授权品类权限
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-供需专员-授权品类权限
-- ##CallType[ExSql]

-- ##input sdPathGuid char[36] NOTNULL;采购供应关联路径guid，必填
-- ##input demandPathGuid char[36] NOTNULL;采购路径guid，必填
-- ##input userId string[36] NOTNULL;目标用户id(询价用户id)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @flag1=case when exists(select 1 from coz_server2_sys_user_demand_path where user_id='{userId}' and demand_path_guid='{demandPathGuid}' and del_flag='0') then '0' else '1' end
;
insert into coz_server2_sys_user_demand_path(guid,user_id,sd_path_guid,demand_path_guid,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{userId}' as user_id
,'{sdPathGuid}' as sdPathGuid
,'{demandPathGuid}' as demand_path_guid
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_cattype_sd_path
where 
guid='{sdPathGuid}' and @flag1='1'