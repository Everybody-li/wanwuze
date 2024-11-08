-- ##Title 查询采购路径和供应路径信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 查询采购路径和供应路径信息
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
*
from 
(
select
t2.guid as sdPathGuid
,t1.name
,t1.all_path_name as allPathName
,t1.guid
,'demand' as sdFlag
,t1.type
from
coz_cattype_demand_path t1
left join
coz_cattype_sd_path t2
on t2.demand_path_guid=t1.guid
where  t2.guid ='{sdPathGuid}' and t1.del_flag='0' and t2.del_flag='0'
union all
select
t2.guid as sdPathGuid
,t1.name
,t1.all_path_name as allPathName
,t1.guid
,'supply' as sdFlag
,t1.type
from
coz_cattype_supply_path t1
left join
coz_cattype_sd_path t2
on t2.supply_path_guid=t1.guid
where  t2.guid ='{sdPathGuid}' and t1.del_flag='0' and t2.del_flag='0'
)t
