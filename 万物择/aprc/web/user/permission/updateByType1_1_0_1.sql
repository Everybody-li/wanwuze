-- ##Title web-更新用户账号操作权限
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-更新用户账号操作权限
-- ##CallType[ExSql]

-- ##input userId char[36] NOTNULL;用户id，必填
-- ##input status int[>=0] NOTNULL;权限状态（0：禁用，1：启用），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- {url:[http://127.0.0.1:8011/ProxyService/app_user_remove_login?userid={userId}]/url}
delete from coz_app_user_permission_detail where permission_guid in (select guid from coz_app_user_permission where user_id='{userId}' and type=1)
;
delete from coz_app_user_permission where user_id='{userId}' and type=1
;
set @permissionguid=uuid()
;
INSERT INTO coz_app_user_permission 
(guid,user_id,type,status,remark,del_flag,create_by,create_time,update_by,update_time) 
select 
@permissionguid as guid
,'{userId}' as user_id
,1 as type
,{status} as status
,'' as remark
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
;
INSERT INTO coz_app_user_permission_log 
(guid,user_id,type,active,remark,create_by,create_time) 
select 
@permissionguid as guid
,'{userId}' as user_id
,1 as type
,{status} as status
,'' as remark
,'{curUserId}' as create_by
,now() as create_time
;
update sys_app_user
set status=if('{status}'='1','1','0')
,update_by='{curUserId}'
,update_time=now()
where guid='{userId}'