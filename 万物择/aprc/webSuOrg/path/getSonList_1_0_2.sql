-- ##Title 查询个人/企业儿子路径列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 查询个人/企业儿子路径列表
-- ##CallType[QueryData]

-- ##input loginCode string[2] NOTNULL;路径guid（可能有多个），必填
-- ##input allPathGuids string[1000] NOTNULL;路径guid（可能有多个），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
*
from
(
select
t1.cattype_guid as cattypeGuid
,t1.worg_norder as norder
,t3.norder as norder1
,t1.guid as pathGuid
,t1.all_path_name as allPathName
,t1.name as pathName
,t1.icon
,t2.guid as sdPathGuid
,'supply' as sdFlag
,t3.mode
,t1.id
,t4.login_code as loginCode
,case when exists(select 1 from coz_cattype_supply_path where parent_guid=t1.guid and del_flag='0') then '1' else '0' end as hasSon
from
coz_cattype_supply_path t1
left join
coz_cattype_sd_path t2
on t2.supply_path_guid=t1.guid
inner join
coz_cattype_fixed_data t3
on t1.cattype_guid=t3.guid
inner join
coz_cattype_supply_path_lgcode t4
on t1.guid=t4.supply_path_guid
where  t1.parent_guid in({allPathGuids}) and t1.del_flag='0' and t3.del_flag='0' and t4.del_flag='0' and (t2.del_flag='0' or t2.guid is null) and (t1.display_type='2' or t1.display_type='9') and t4.login_code='{loginCode}'
)t
order by t.norder
