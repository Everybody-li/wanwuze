-- ##Title web-查询供应专员的权限供应机构列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供应专员的权限供应机构列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input staffUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input orgName string[50] NULL;品类名称，非必填



select
count(1) as total
from
coz_org_relate_staff t
inner join
coz_org_info t1
on t.org_user_id=t1.user_id
where t1.del_flag='0' and t.del_flag='0' and t.staff_user_id='{staffUserId}' and (t1.name like '%{orgName}%' or '{orgName}'='')

