-- ##Title web-查询服务预约服务对象
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务预约服务对象
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t1.guid as sdPathGuid
,t1.name as sdPName
,ifnull(t2.num,0) as num
from 
coz_cattype_sd_path t1
left join
(
select
sum(num) as num
,guid
from
(
select t3.guid,count(t1.guid) as num from coz_serve2_serve_task_tobject_result t1
inner join coz_serve2_serve_task t2 on t1.serve_task_guid = t2.guid
inner join coz_cattype_sd_path t3 on t2.sd_path_guid = t3.guid
where t1.result = 1 and length(t3.name) > 0 and t1.del_flag = '0' and t2.del_flag = '0' and t3.del_flag = '0'
group by t3.guid
union
select t3.guid,count(t1.guid) as num from coz_serve2_commu_task_tobject t1
inner join coz_serve2_commu_task t2 on t1.commu_task_guid = t2.guid
inner join coz_cattype_sd_path t3 on t2.sd_path_guid = t3.guid
where t1.result = 1 and length(t3.name) > 0 and t1.del_flag = '0' and t2.del_flag = '0' and t3.del_flag = '0'
group by t3.guid
)t
group by guid
)t2
on t1.guid=t2.guid
where 
t1.del_flag='0' and t1.name<>''
order by t1.norder desc