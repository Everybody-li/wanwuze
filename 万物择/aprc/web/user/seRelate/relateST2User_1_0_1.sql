-- ##Title web-供应专员用户管理-关联服务机构
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-供应专员用户管理-关联服务机构
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input seorgGuid string[36] NOTNULL;机构专属码，必填
-- ##input targetUserGuid string[36] NOTNULL;机构专属码，必填

set @flag1=(select case when exists(select 1 from coz_serve_org where guid='{seorgGuid}' and del_flag='0') then '1' else '0' end)
;
set @flag2=(select case when exists(select 1 from coz_serve_org_relate_staff where staff_type='2' and staff_user_id='{targetUserGuid}' and del_flag='0') then '0' else '1' end)
;
delete from coz_serve_org_relate_staff where seorg_guid='{seorgGuid}' and staff_user_id='{curUserId}' and staff_type='2' and @flag1='1' and @flag2='1'
;
update coz_serve_org_relate_staff_log
set
detach_flag='1'
,detach_time=now()
,detach_by='{seorgGuid}'
where
seorg_guid='{seorgGuid}' and staff_user_id='{curUserId}' and staff_type='2' and detach_flag='0' and @flag1='1' and @flag2='1'
;
insert into coz_serve_org_relate_staff(guid,seorg_guid,staff_user_id,staff_type,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{seorgGuid}' as user_name
,'{targetUserGuid}' as staff_user_id
,'2' as staff_type
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1' and @flag2='1' and not exists(select 1 from coz_serve_org_relate_staff where seorg_guid='{seorgGuid}' and staff_user_id='{targetUserGuid}' and staff_type='2' and del_flag='0')
limit 1
;
insert into coz_serve_org_relate_staff_log(guid,seorg_guid,staff_user_id,staff_type,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{seorgGuid}' as user_name
,'{targetUserGuid}' as staff_user_id
,'2' as staff_type
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1' and @flag2='1'
limit 1
;
select 
case when(@flag1='1' and @flag2='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '服务机构已被删除，不可关联，请刷新' when(@flag2='0') then '当前供应专员有关联的服务机构，请先解除后再关联！' else '操作成功' end as msg