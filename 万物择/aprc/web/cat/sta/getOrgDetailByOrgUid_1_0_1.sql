-- ##Title web-交易条件管理-查询交易组织跟踪管理-查看供应组织关联关系
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-交易条件管理-查询交易组织跟踪管理-查看供应组织关联关系
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input orgUserId char[36] NULL;机构用户uid，必填

select 
t4.guid as seorgGuid
,t4.user_name as seorgName
,left(t4.create_time,16) as seorgCreateTime
,left(t2.create_time,16) as createTime
,t5.user_name as userName
,t5.nick_name as nickName
,t5.nation
,t5.phonenumber
from 
coz_org_relate_staff_log t1
inner join
coz_serve_org_relate_suorg t3
on t1.guid=t3.org_stalog_guid
inner join
coz_serve_org_relate_staff_log t2
on t2.guid=t3.seorg_stalog_guid
inner join
coz_serve_org t4
on t2.seorg_guid=t4.guid
inner join
sys_user t5
on t1.staff_user_id=t5.user_id
inner join
sys_user t6
on t2.staff_user_id=t6.user_id and t2.staff_type='2'
where t1.del_flag='0' and t1.detach_flag='0' and t2.detach_flag='0' and t1.org_user_id='{orgUserId}'

