-- ##Title web-删除用户类型信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除用户类型信息
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input phonenumber string[11] NOTNULL;机构专属码，必填
-- ##input objectOrgGuid string[36] NOTNULL;机构专属码，必填


update 
coz_target_object_org t7
left join
coz_target_object_profile t8
on t8.object_org_guid=t7.guid
left join
coz_target_object_profile_filed t9
on t9.profile_guid=t8.guid
set t7.del_flag='2'
,t8.del_flag='2'
,t9.del_flag='2'
,t7.update_by='{curUserId}'
,t7.update_time=now()
,t8.update_by='{curUserId}'
,t8.update_time=now()
,t9.update_by='{curUserId}'
,t9.update_time=now()
where t7.guid='{objectOrgGuid}'
;