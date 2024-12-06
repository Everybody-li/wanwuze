-- ##Title web-编辑注册验证号码管理
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-编辑注册验证号码管理
-- ##CallType[ExSql]

-- ##input orgGuid char[36] NOTNULL;机构名称guid，必填
-- ##input phonenumber string[11] NOTNULL;登录用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @flag1=(select case when not exists(select 1 from coz_org_info where phonenumber='{phonenumber}' and guid<>'{orgGuid}') then '1' else '0' end)
;
update coz_org_info
set 
phonenumber='{phonenumber}'
,update_by='{curUserId}'
,update_time=now()
where guid='{orgGuid}'and user_id='' and @flag1='1'
;
