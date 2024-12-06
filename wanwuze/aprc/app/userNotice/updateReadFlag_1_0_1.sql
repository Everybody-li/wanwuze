-- ##Title web-给服务机构批量解除授权品类
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-给服务机构批量解除授权品类
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_app_user_notice
set
read_flag='2'
,read_time=now()
,update_by='{curUserId}'
,update_time=now()
where user_id='{curUserId}' and del_flag='0' and read_flag='1'
;