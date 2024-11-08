-- ##Title web-删除各角色账号信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除各角色账号信息
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input categoryGuid string[36] NOTNULL;要删除的用户id，必填
-- ##input userId string[36] NOTNULL;要删除的用户id，必填

update coz_server2_sys_user_category
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where user_id='{userId}' and category_guid='{categoryGuid}'
;
