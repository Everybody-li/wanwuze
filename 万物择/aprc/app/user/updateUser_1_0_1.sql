-- ##Title app-修改用户信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-06-11
-- ##Describe app-修改用户信息
-- ##CallType[QueryData]

-- ##input userId char[36] NOTNULL;用户id
-- ##input username string[30] NOTNULL;用户姓名

update sys_app_user
set user_name='{username}'
where guid='{userId}'