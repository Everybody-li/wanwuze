-- ##Title 查询固化需求场景信息列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 查询固化需求场景信息列表
-- ##CallType[QueryData]
select
*
from
(
select 
t1.cattype_guid as cattypeGuid
,t4.name as cattypeName
,t4.norder
,t1.guid as sdPathGuid
,t1.demand_path_guid as demandPathGuid
,t3.all_path_name as demandPathName
,t1.supply_path_guid as supplyPathGuid
,t2.all_path_name as supplyPathName
,ifnull((select wscene_norder from coz_cattype_demand_path where guid=t3.parent_guid),0) as norder1
,t3.wscene_norder as norder2
,t3.type
from 
coz_cattype_sd_path t1
left join 
coz_cattype_supply_path t2 
on t1.supply_path_guid = t2.guid
left join 
coz_cattype_demand_path t3 
on t1.demand_path_guid = t3.guid
left join 
coz_cattype_fixed_data t4 
on t1.cattype_guid = t4.guid
where t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and t4.del_flag='0'
)t
order by t.norder,type,t.norder1,t.norder2
