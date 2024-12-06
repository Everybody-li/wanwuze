-- ##Title web-编辑机构名称信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-编辑机构名称信息
-- ##CallType[ExSql]

-- ##input seorgGuid char[36] NOTNULL;机构信息guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input seorgName string[50] NOTNULL;机构名称，必填

set @flag1=(select case when not exists(select 1 from coz_serve_org where user_name='{seorgName}' and guid<>'{seorgGuid}' and del_flag='0') then '1' else '0' end)
;
update coz_serve_org
set 
user_name='{seorgName}'
,update_by='{curUserId}'
,update_time=now()
where guid='{seorgGuid}' and @flag1='1'
;
select 
case when(@flag1='1') then '1' else '0' end as okFlag
,case when(@flag1='1') then '' else '机构名称已存在，不可编辑' end as notOkReason
;