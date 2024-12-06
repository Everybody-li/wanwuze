-- ##Title 查询个人/企业一级列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 查询个人/企业一级列表
-- ##CallType[QueryData]

-- ##input type enum[1,2,3] 1;主体类型(1：个人，2：企业)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
*
from
(
select
t1.cattype_guid as cattypeGuid
,t1.app_norder as norder
,t1.guid as pathGuid
,t1.name as pathName
,t1.icon
,concat('''',t1.guid,'''') as allPathGuids
,'demand' as sdFlag
,t1.id as id
,t2.guid as sdPathGuid
,t3.mode
,case when exists(select 1 from coz_cattype_demand_path where parent_guid=t1.guid and del_flag='0') then '1' else '0' end as hasSon
from 
coz_cattype_demand_path t1
left join 
coz_cattype_sd_path t2
on t2.demand_path_guid=t1.guid
left join
coz_cattype_fixed_data t3
on t1.cattype_guid=t3.guid
where 
t1.type='{type}' and t1.level=2 and t1.display_type='1' and t1.del_flag='0'
union all
select
t1.cattype_guid as cattypeGuid
,t1.app_norder as norder
,t1.guid as pathGuid
,t1.name as pathName
,t1.icon
,concat('''',t1.guid,'''') as allPathGuids
,'supply' as sdFlag
,t1.id as id
,t2.guid as sdPathGuid
,t3.mode
,case when exists(select 1 from coz_cattype_supply_path where parent_guid=t1.guid and del_flag='0') then '1' else '0' end as hasSon
from 
coz_cattype_supply_path t1
left join 
coz_cattype_sd_path t2
on t2.supply_path_guid=t1.guid
left join
coz_cattype_fixed_data t3
on t1.cattype_guid=t3.guid
where 
t1.type='{type}' and (t1.guid='976c6ea8-f200-11ec-bace-0242ac120003')
)t
order by t.norder