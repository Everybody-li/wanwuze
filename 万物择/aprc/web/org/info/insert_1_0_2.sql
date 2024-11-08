-- ##Title web-新增机构名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新增机构名称
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orgName string[50] NOTNULL;签约主体(1：机构，2：个人)，必填

set @flag1=(select case when not exists(select 1 from coz_org_info where name='{orgName}' and del_flag='0') then '1' else '0' end)
;
set @flag2=(select case when not exists(select 1 from sys_weborg_user where user_name='{orgName}' and del_flag='0') then '1' else '0' end)
;
set @userid=uuid()
;
insert into coz_org_info(guid,name,user_id,del_flag,create_by,create_time,update_by,update_time)
select
UUID()
,'{orgName}'
,@userid
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_guidance_criterion t
where @flag1='1' and @flag2='1'
limit 1
;
insert into sys_weborg_user(guid,user_name,nick_name,phonenumber,del_flag,create_by,create_time,update_by,update_time)
select
@userid
,'{orgName}'
,'{orgName}'
,''
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_guidance_criterion
where @flag1='1' and @flag2='1'
limit 1
;
select 
case when(@flag1='1' and @flag2='1') then '1' else '0' end as okFlag
,case when(@flag1='1' and @flag2='1') then '' else '机构名称已存在，不可新增' end as notOkReason