-- ##Title web-查询服务对象的服务专员
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务对象的服务专员
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input orgUserId string[36] NULL;供应机构用户id，必填


select
t1.user_name as userName
,t1.nick_name as nickName
,t1.nation
,t1.phonenumber
,left(t.create_time,16) as relateTime
,left(t1.create_time,16) as registerTime
from
coz_org_relate_staff t
inner join
sys_user t1
on t1.user_id=t.staff_user_id
where t1.del_flag='0' and t.del_flag='0' and t.org_user_id='{orgUserId}'
order by t.id desc


