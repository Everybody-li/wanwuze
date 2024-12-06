-- ##Title web-查询目标用户选择列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询目标用户选择列表
-- ##CallType[QueryData]

-- ##input orgName string[60] NULL;机构名称(模糊搜索)，非必填
-- ##input orgType string[30] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input registerCity string[30] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input roleType string[30] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input start int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input end int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input sdPathGuid string[36] NOTNULL;服务名称guid，必填
-- ##input sendTimes int[>=0] NOTNULL;派发次数(全等)，必填
-- ##input result string[1] NULL;沟通结果(2-拒绝服务，3-未接通，4-无效号码,5-时间到被收回)，非必填


set @orgType = cast(if('{orgType}'='无','','{orgType}') as char character set utf8)
;
set @roleType = cast(if('{roleType}'='无','','{roleType}') as char character set utf8)
;
set @registerCity = cast(if('{registerCity}'='无','','{registerCity}') as char character set utf8)
;
with notEndTasks as (
    select t1.guid, t2.object_guid
    from coz_serve2_commu_task t1
             inner join coz_serve2_commu_task_tobject t2 on t1.guid = t2.commu_task_guid
    where t1.del_flag = 0
      and t2.del_flag = 0
      and t1.end_date >= curdate()
),
     endedTasks as (
         select t1.guid, t2.guid as ctObjGuid, t2.object_guid, t2.object_org_guid, t2.result, t2.send_times
         from coz_serve2_commu_task t1
                  inner join coz_serve2_commu_task_tobject t2 on t1.guid = t2.commu_task_guid
         where t1.del_flag = 0
           and t2.del_flag = 0
           and t1.end_date < curdate()
     ),
     queryTobjs as (
         select t1.object_guid,
                max(t1.id) as id,
                t2.phonenumber,
                t1.guid,
                t1.org_name,
                t1.register_city,
                t1.org_type,
                t1.r_type,
                t2.name    as obj_name
         from coz_target_object t2
                  inner join coz_target_object_org t1 on t2.guid = t1.object_guid
         where t1.del_flag = '0'
           and (t1.org_name like '%{orgName}%' or '{orgName}' = '')
           and (t1.org_type = @orgType and t1.r_type = @roleType and t1.register_city = @registerCity)
         group by t1.object_guid)
				 
select obj.guid                         as objectOrgGuid
     , obj.object_guid                  as objectGuid
     , concat('(+86)', obj.phonenumber) as phonenumber
     , obj.obj_name                     as nickName
     , obj.org_name                     as orgName
     , obj.r_type                       as roleType
     , obj.org_type                     as orgType
     , obj.register_city                as registerCity
from queryTobjs obj
         left join notEndTasks net on obj.object_guid = net.object_guid
         left join endedTasks et on obj.object_guid = et.object_guid
where net.guid is null
  and (
        ('{sendTimes}'= '0' and et.ctObjGuid is null) 
        or
    ('{sendTimes}' > '0' and et.ctObjGuid is not null and et.send_times = '{sendTimes}' and et.result = '{result}')
    )
  and ((select count(1) from endedTasks t where t.object_guid = obj.object_guid and t.result = 1) = 0)
order by obj.id desc
limit {start},{end};