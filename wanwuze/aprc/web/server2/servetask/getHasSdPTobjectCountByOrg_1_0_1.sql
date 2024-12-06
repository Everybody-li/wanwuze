-- ##Title web-查询目标用户选择列表总数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询目标用户选择列表总数量
-- ##CallType[QueryData]

-- ##input orgName string[60] NULL;机构名称(模糊搜索)，非必填
-- ##input orgType string[30] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input registerCity string[30] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input roleType string[30] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output totalCount int[>=0] 1;总数量

select 
count(1) as totalCount
from
(
select
t2.object_guid
from 
coz_target_object t1
inner join
(
select max(guid) as guid,object_guid,org_name,r_type,org_type,register_city from coz_target_object_org t 
where (t.org_name like'%{orgName}%' or '{orgName}'='') and t.del_flag='0' and '{sdPathGuid}'<>'' and ((t.org_type='{orgType}' and t.register_city='{registerCity}' and t.r_type='{roleType}') or (exists(select 1 from coz_serve2_serve_task t4 where t4.sd_path_guid='{sdPathGuid}' and  t4.del_flag='0' and t4.end_date>=left(now(),10)) and not exists(select 1 from coz_serve2_serve_task t4 inner join coz_serve2_serve_task_tobject t5 on t4.guid=t5.serve_task_guid where t4.sd_path_guid='{sdPathGuid}' and t5.object_guid=t.object_guid and t4.del_flag='0' and t5.del_flag='0')))
group by object_guid,org_name,r_type,org_type,register_city
) t2
on t1.guid=t2.object_guid
inner join
coz_serve2_commu_task_tobject t3
on t2.guid=t3.object_org_guid
where 
t1.del_flag='0' and t3.del_flag='0'  and t3.result='1' 
group by t2.object_guid,concat('(+86)',t1.phonenumber),t1.name,t2.org_name,t2.r_type,t2.org_type,t2.register_city,t1.id
)t