-- ##Title web-系统登录权限管理-授权登录系统
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-系统登录权限管理-授权登录系统
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orgUserId char[36] NOTNULL;签约主体(1：机构，2：个人)，必填
-- ##input lgCodeGuid char[36] NOTNULL;机构路径guid，必填

insert into coz_org_info_lgcode (guid,user_id,lgcode_guid,del_flag,create_by,create_time,update_by,update_time)
select
UUID()
,'{orgUserId}'
,'{lgCodeGuid}'
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_cattype_fixed_data t
where not exists(select 1 from coz_org_info_lgcode where user_id='{orgUserId}' and lgcode_guid='{lgCodeGuid}' and del_flag='0') and  exists(select 1 from coz_org_info where user_id='{orgUserId}' and del_flag='0')
limit 1
;