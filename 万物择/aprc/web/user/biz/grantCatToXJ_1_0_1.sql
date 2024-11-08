-- ##Title web-询价专员-授权品类名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-询价专员-授权品类名称
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;档案模板guid，必填
-- ##input userId string[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


insert into coz_server2_sys_user_category(guid,user_id,category_guid,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{userId}' as user_id
,'{categoryGuid}' as category_guid
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_category_info
where 
guid='{categoryGuid}' and not exists(select 1 from coz_server2_sys_user_category where user_id='{userId}' and category_guid='{categoryGuid}' and del_flag='0')