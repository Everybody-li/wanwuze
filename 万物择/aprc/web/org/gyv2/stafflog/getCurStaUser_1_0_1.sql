-- ##Title web-查询当前关联供应专员信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询当前关联供应专员信息
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input orgUserGuid string[36] NOTNULL;机构用户id，必填



select
t2.staff_user_id as userId
,left(t1.create_time,16) as registerTime
,left(t2.create_time,16) as relateTime
,t3.user_name as userName
,t3.nick_name as nickName
,t3.nation
,concat('(+86)',t3.phonenumber) as phonenumber
from
coz_org_info t1
inner join
coz_org_gyv2_relate_staff t2
on t1.user_id=t2.org_user_id
inner join
sys_user t3
on t2.staff_user_id=t3.user_id
where t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and t1.user_id='{orgUserGuid}' 
order by t2.id desc

