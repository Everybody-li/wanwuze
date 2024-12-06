-- ##Title web-编辑注册验证号码管理
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-编辑注册验证号码管理
-- ##CallType[ExSql]

-- ##input phonenumber string[11] NOTNULL;登录用户id，必填
-- ##input userId string[36] NOTNULL;登录用户id，必填
-- ##input name string[100] NOTNULL;用户姓名，必填

update coz_app_phonenumber
set 
user_id='{userId}'
,name='{name}'
,update_by='1'
,update_time=now()
where phonenumber='{phonenumber}'
;
