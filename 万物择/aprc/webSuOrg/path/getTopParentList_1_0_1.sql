-- ##Title 查询个人/企业一级列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 查询个人/企业一级列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
select
*
,'1' as hasSon
from
(
select
GROUP_CONCAT(t1.cattype_guid) as cattypeGuid
,min(t1.norder) as norder
,GROUP_CONCAT(t1.guid) as pathGuid
,t1.name as pathName
,t1.icon
,GROUP_CONCAT(concat('''',t1.guid,'''')) as allPathGuids
,'demand' as sdFlag
,GROUP_CONCAT(t1.id) as id
,t2.guid as sdPathGuid
,min(t3.norder) as norder1
from 
coz_cattype_demand_path t1
left join 
coz_cattype_sd_path t2
on t2.demand_path_guid=t1.guid
left join
coz_cattype_fixed_data t3
on t1.cattype_guid=t3.guid
where 
t1.level=1 and (t1.display_type='2' or t1.display_type='9') and t1.del_flag='0'
group by t1.name,t1.icon,t2.guid
union all
select
GROUP_CONCAT(t1.cattype_guid) as cattypeGuid
,min(t1.norder) as norder
,GROUP_CONCAT(t1.guid) as pathGuid
,t1.name as pathName
,t1.icon
,GROUP_CONCAT(concat('''',t1.guid,'''')) as allPathGuids
,'supply' as sdFlag
,GROUP_CONCAT(t1.id) as id
,t2.guid as sdPathGuid
,min(t3.norder) as norder1
from 
coz_cattype_supply_path t1
left join 
coz_cattype_sd_path t2
on t2.supply_path_guid=t1.guid
left join
coz_cattype_fixed_data t3
on t1.cattype_guid=t3.guid
where 
t1.level=1 and (t1.display_type='2' or t1.display_type='9') and t1.del_flag='0'
group by t1.name,t1.icon,t2.guid

)t
order by t.norder