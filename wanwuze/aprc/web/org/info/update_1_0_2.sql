-- ##Title web-编辑机构名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-编辑机构名称
-- ##CallType[ExSql]

-- ##input orgGuid char[36] NOTNULL;机构信息guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orgName string[50] NOTNULL;机构名称，必填
-- ##input type string[50] NULL;机构路径guid，必填

set @flag1=(select case when not exists(select 1 from coz_org_info where name='{orgName}' and guid<>'{orgGuid}' and del_flag='0') then '1' else '0' end)
;
set @userid=(select user_id from coz_org_info where guid='{orgGuid}')
;
update coz_org_info
set 
name='{orgName}'
,update_by='{curUserId}'
,update_time=now()
where guid='{orgGuid}' and @flag1='1'
;
update sys_weborg_user
set 
user_name='{orgName}'
,nick_name='{orgName}'
,update_by='{curUserId}'
,update_time=now()
where guid=@userid and @flag1='1'
;
select 
case when(@flag1='1') then '1' else '0' end as okFlag
,case when(@flag1='1') then '' else '机构名称已存在，不可编辑' end as notOkReason
;