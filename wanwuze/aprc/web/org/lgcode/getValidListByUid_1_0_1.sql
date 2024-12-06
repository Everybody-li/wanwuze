-- ##Title web-系统登录权限管理-查询当前已授权登录系统列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-系统登录权限管理-查询当前已授权登录系统列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orgUserId char[36] NOTNULL;机构用户id，必填


select 
t2.guid as lgCodeGuid
,t3.login_sysname as loginSysName
,left(t2.create_time,16) as authorizationTime
from 
coz_org_info t1
inner join
coz_org_info_lgcode t2
on t1.user_id=t2.user_id
inner join
coz_lgcode_fixed_data t3
on t2.lgcode_guid=t3.guid
where t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and t1.user_id='{orgUserId}' and (t3.login_sysname like '%{lgSysName}%' or '{lgSysName}'='')
order by t2.id desc


