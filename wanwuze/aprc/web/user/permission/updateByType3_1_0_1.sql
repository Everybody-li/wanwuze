-- ##Title web-更新用户供应操作权限
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-更新用户供应操作权限
-- ##CallType[ExSql]

-- ##input userId char[36] NOTNULL;用户id，必填
-- ##input status int[>=0] NOTNULL;权限状态（0：禁用，1：启用），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

delete from coz_app_user_permission where user_id='{userId}' and type=3
;
set @permissionguid=uuid()
;
INSERT INTO coz_app_user_permission 
(guid,user_id,type,status,remark,del_flag,create_by,create_time,update_by,update_time) 
select 
@permissionguid as guid
,'{userId}' as user_id
,3 as type
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
,3 as type
,{status} as status
,'' as remark
,'-1' as create_by
,now() as create_time
;
update coz_chat_demand_request_supply_detail
set del_flag='2'
where del_flag='0 'and '{status}'='1' and request_supply_guid in (select guid from coz_chat_demand_request_supply where recruit_user_id='{userId}' and del_flag='0' and '{status}'='1' and send_resume_flag='2')
;
update coz_demand_request_supply
set del_flag='2'
where del_flag='0 'and '{status}'='1' and user_id='{userId}' and supply_price_status='1'
;
update coz_category_supplier
set del_flag='2'
where user_id='{userId}' and del_flag='0' and '{status}'='1' 
;

update coz_chat_demand_request_supply
set del_flag='2'
where recruit_user_id='{userId}' and del_flag='0' and '{status}'='1' and send_resume_flag='2'
;