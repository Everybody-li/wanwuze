-- ##Title web-更新用户采购操作权限
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-更新用户采购操作权限
-- ##CallType[ExSql]

-- ##input userId char[36] NOTNULL;用户id，必填
-- ##input status int[>=0] NOTNULL;权限状态（0：禁用，1：启用），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

delete from coz_app_user_permission where user_id='{userId}' and type=2
;
set @permissionguid=uuid()
;
INSERT INTO coz_app_user_permission 
(guid,user_id,type,status,remark,del_flag,create_by,create_time,update_by,update_time) 
select 
@permissionguid as guid
,'{userId}' as user_id
,2 as type
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
,2 as type
,{status} as status
,'' as remark
,'{curUserId}' as create_by
,now() as create_time
;
update coz_demand_request_price_plate
set del_flag='2'
where request_price_guid in(select guid from coz_demand_request_price where request_guid in(select guid from coz_demand_request where done_flag=0 and user_id='{userId}' and del_flag='0')) and del_flag='0' and '{status}'='1'
;
update coz_demand_request_price
set del_flag='2'
where request_guid in(select guid from coz_demand_request where done_flag='0' and user_id='{userId}' and del_flag='0') and del_flag='0' and '{status}'='1'
;
update coz_demand_request_supply
set del_flag='2'
where request_guid in(select guid from coz_demand_request where done_flag='0' and user_id='{userId}' and del_flag='0') and del_flag='0' and '{status}'='1'
;
update coz_demand_request_plate
set del_flag='2'
where request_guid in(select guid from coz_demand_request where done_flag='0' and user_id='{userId}' and del_flag='0') and del_flag='0' and '{status}'='1'
;
update coz_demand_request
set del_flag='2'
where done_flag=0  and user_id='{userId}' and del_flag='0' and '{status}'='1' 
;

update coz_chat_demand_request_detail
set del_flag='2'
where de_request_guid in(select guid from coz_chat_demand_request where send_time is null and user_id='{userId}' and del_flag='0') and del_flag='0' and '{status}'='1'
;
update coz_chat_demand_request
set del_flag='2'
where send_time is null  and user_id='{userId}' and del_flag='0' and '{status}'='1' 
;