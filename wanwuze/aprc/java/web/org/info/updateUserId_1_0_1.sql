-- ##Title web-编辑注册验证号码管理
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-编辑注册验证号码管理
-- ##CallType[ExSql]

-- ##input phonenumber string[11] NOTNULL;登录用户id，必填
-- ##input userId string[36] NOTNULL;登录用户id，必填

update coz_org_info
set 
user_id='{userId}'
,update_by='{userId}'
,update_time=now()
where phonenumber='{phonenumber}'
;
