-- ##Title web-账号申请人管理-添加账号申请人
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-账号申请人管理-添加账号申请人
-- ##CallType[ExSql]

-- ##input orgGuid char[36] NOTNULL;机构名称guid，必填
-- ##input targetUserId char[36] NOTNULL;服务专员用户guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @flag1=(select case when exists(select 1 from coz_org_info where guid='{orgGuid}' and account_by='') then '1' else '0' end)
;
update coz_org_info
set 
account_by='{targetUserId}'
,account_time=now()
,update_by='{curUserId}'
,update_time=now()
where guid='{orgGuid}'and account_by='' and @flag1='1'
;
select 
case when(@flag1='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '当前机构已有账号申请人，不可再次操作，请联系管理员！' else '操作成功' end as msg