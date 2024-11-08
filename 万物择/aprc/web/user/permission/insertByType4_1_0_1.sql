-- ##Title web-更新用户品类采购操作权限
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-更新用户品类采购操作权限
-- ##CallType[ExSql]

-- ##input userId char[36] NOTNULL;用户id，必填
-- ##input remark string[200] NULL;理由（type=4\5，必填，其他时候非必填），非必填
-- ##input categoryGuid char[36] NULL;品类guid（type=4\5，必填，其他时候非必填），非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

INSERT INTO coz_app_user_permission_detail
(guid,user_id,type,biz_table,biz_guid,remark,del_flag,create_by,create_time,update_by,update_time) 
select 
uuid()
,'{userId}' as userId
,4 as type
,'品类表' as biz_table
,'{categoryGuid}' as biz_guid
,'{remark}' as remark
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_category_info 
where guid='{categoryGuid}'
;
INSERT INTO coz_app_user_permission_log 
(guid,user_id,type,active,remark,create_by,create_time) 
select 
uuid() as guid
,'{userId}' as user_id
,4 as type
,1 as status
,'{remark}' as remark
,'{curUserId}' as create_by
,now() as create_time
;
update coz_demand_request_price_plate
set del_flag='2'
where request_price_guid in(select guid from coz_demand_request_price where request_guid in(select guid from coz_demand_request where done_flag=0 and category_guid='{categoryGuid}' and user_id='{userId}' and del_flag='0')) and del_flag='0'
;
update coz_demand_request_price
set del_flag='2'
where request_guid in(select guid from coz_demand_request where done_flag='0' and category_guid='{categoryGuid}' and user_id='{userId}' and del_flag='0') and del_flag='0' 
;
update coz_demand_request_supply
set del_flag='2'
where request_guid in(select guid from coz_demand_request where done_flag='0' and category_guid='{categoryGuid}' and user_id='{userId}' and del_flag='0') and del_flag='0' 
;
update coz_demand_request_plate
set del_flag='2'
where request_guid in(select guid from coz_demand_request where done_flag='0' and category_guid='{categoryGuid}' and user_id='{userId}' and del_flag='0') and del_flag='0'
;
update coz_demand_request
set del_flag='2'
where done_flag=0 and category_guid='{categoryGuid}' and user_id='{userId}' and del_flag='0'
;