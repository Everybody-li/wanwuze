-- ##Title web-查询目标用户总数量

-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询目标用户总数量

-- ##CallType[QueryData]

-- ##input orgType string[30] NOTNULL;机构类型，必填
-- ##input orgName string[60] NULL;机构名称(模糊搜索)，非必填
-- ##input roleType string[30] NOTNULL;角色类型，必填
-- ##input registerCity string[30] NOTNULL;所在区域，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output totalCount int[>=0] 1;累计反馈内容已被回复但是未查看的数量


select 
count(1) as totalCount
from 
(
select object_guid,max(id) as id from 
coz_target_object_org t 
where 
(t.org_name like '%{orgName}%' or '{orgName}'='') and t.del_flag='0' and t.org_type='{orgType}' and t.register_city='{registerCity}' and t.r_type='{roleType}'
group by object_guid
)t
inner join
coz_target_object_org t1
on t.id=t1.id
inner join
coz_target_object t2
on t2.guid=t1.object_guid