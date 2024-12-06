-- ##Title 查询个人/企业儿子路径列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 查询个人/企业儿子路径列表
-- ##CallType[QueryData]

-- ##input allPathGuids string[1000] NOTNULL;路径guid（可能有多个），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
*
from
(
select
t1.cattype_guid as cattypeGuid
,t1.norder
,t3.norder as norder1
,t1.guid as pathGuid
,t1.name as pathName
,t1.icon
,t2.guid as sdPathGuid
,'demand' as sdFlag
,t3.mode
,t1.id
,case when exists(select 1 from coz_cattype_demand_path where parent_guid=t1.guid and del_flag='0') then '1' else '0' end as hasSon
from
coz_cattype_demand_path t1
left join
coz_cattype_sd_path t2
on t2.demand_path_guid=t1.guid
left join
coz_cattype_fixed_data t3
on t2.cattype_guid=t3.guid
where  t1.parent_guid in({allPathGuids}) and t1.del_flag='0' and (t1.display_type='2' or t1.display_type='9')
union all
select
t1.cattype_guid as cattypeGuid
,t1.norder
,t3.norder as norder1
,t1.guid as pathGuid
,t1.name as pathName
,t1.icon
,t2.guid as sdPathGuid
,'supply' as sdFlag
,t3.mode
,t1.id
,case when exists(select 1 from coz_cattype_supply_path where parent_guid=t1.guid and del_flag='0') then '1' else '0' end as hasSon
from
coz_cattype_supply_path t1
left join
coz_cattype_sd_path t2
on t2.supply_path_guid=t1.guid
left join
coz_cattype_fixed_data t3
on t2.cattype_guid=t3.guid
where  t1.parent_guid in({allPathGuids}) and t1.del_flag='0' and (t1.display_type='2' or t1.display_type='9')
)t
order by t.norder
