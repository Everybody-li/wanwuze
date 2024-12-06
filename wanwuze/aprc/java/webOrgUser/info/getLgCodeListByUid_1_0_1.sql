-- ##Title web-系统登录权限管理-查询可授权登录系统多选列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-系统登录权限管理-查询可授权登录系统多选列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orgUserId char[36] NOTNULL;机构用户id，必填
-- ##input lgCode string[2] NOTNULL;机构用户id，必填

select 
case when exists(select 1 from coz_org_info_lgcode where user_id='{orgUserId}' and lgcode_guid=t.guid and del_flag='0') then '1' else '0' end as selectedFlag
,t.guid as lgCodeGuid
,t.login_code as lgCode
,t.login_sysname as loginSysName
from 
coz_lgcode_fixed_data t
where t.del_flag='0' and t.login_code='{lgCode}'
order by t.norder


