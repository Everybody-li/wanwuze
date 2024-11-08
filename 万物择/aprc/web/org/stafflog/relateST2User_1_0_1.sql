-- ##Title web-关联供应专员
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-关联供应专员
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orgUserGuid string[36] NOTNULL;机构专属码，必填
-- ##input seorgStalogGuid string[36] NOTNULL;机构专属码，必填
-- ##input targetUserId string[36] NOTNULL;机构专属码，必填

set @orgstalogguid=uuid()
;
set @flag1=(select case when exists(select 1 from coz_org_info where user_id='{orgUserGuid}' and del_flag='0') then '1' else '0' end)
;
set @flag2=(select case when exists(select 1 from coz_serve_org_relate_staff_log where guid='{seorgStalogGuid}' and del_flag='0' and detach_flag='1') then '0' else '1' end)
;
set @flag3=(select case when exists(select 1 from coz_org_relate_staff_log where org_user_id='{orgUserGuid}' and staff_user_id='{targetUserId}' and del_flag='0' and detach_flag='0' and staff_type='2') then '0' else '1' end)
;
delete from coz_org_relate_staff where '{oldUserId}'<>'' and org_user_id='{orgUserGuid}' and staff_type='2' and @flag1='1' and @flag2='1' and @flag3='1'
;
update coz_org_relate_staff_log
set 
detach_flag='1'
,detach_time=now()
,update_by='{curUserId}'
,update_time=now()
where 
org_user_id='{orgUserGuid}' and staff_type='2' and staff_user_id='{oldUserId}' and '{oldUserId}'<>'' and @flag1='1' and @flag2='1' and @flag3='1'
;
update coz_serve_org_relate_suorg t
set 
t.detach_flag='1'
,t.detach_time=now()
,update_by='{curUserId}'
,update_time=now()
where 
exists(select 1 from coz_org_relate_staff_log where guid=t.org_stalog_guid and org_user_id='{orgUserGuid}' and detach_flag='0' and staff_type='2') and '{oldUserId}'<>'' and @flag1='1' and @flag2='1' and @flag3='1'
;
insert into coz_org_relate_staff(guid,org_user_id,staff_user_id,staff_type,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{orgUserGuid}' as user_name
,'{targetUserId}' as staff_user_id
,'2' as staff_type
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1' and @flag2='1' and @flag3='1' and not exists(select 1 from coz_org_relate_staff where org_user_id='{orgUserGuid}' and staff_user_id='{targetUserId}' and staff_type='2' and del_flag='0')
limit 1
;
insert into coz_org_relate_staff_log(guid,org_user_id,staff_user_id,staff_type,del_flag,create_by,create_time,update_by,update_time)
select
@orgstalogguid as guid
,'{orgUserGuid}' as user_name
,'{targetUserId}' as staff_user_id
,'2' as staff_type
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1' and @flag2='1' and @flag3='1' 
limit 1
;
insert into coz_serve_org_relate_suorg(guid,seorg_stalog_guid,org_stalog_guid,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{seorgStalogGuid}' as user_name
,@orgstalogguid as staff_user_id
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1' and @flag2='1' and @flag3='1'
limit 1
;
select 
case when(@flag1='1' and @flag2='1' and @flag3='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '机构已被删除，不可关联，请刷新' when(@flag2='0') then '当前供应专员已和服务机构解除关联，不可关联，请刷新' when(@flag3='0') then '已关联当前供应专员，无需重复操作，请刷新' else '操作成功' end as notOkReason