-- ##Title 用户-将用户状态改为启用
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 用户-将用户状态改为启用
-- ##CallType[ExSql]

-- ##input userId string[36] NOTNULL;登录用户id，必填

update sys_app_user
set status='0'
where guid='{userId}'
;
