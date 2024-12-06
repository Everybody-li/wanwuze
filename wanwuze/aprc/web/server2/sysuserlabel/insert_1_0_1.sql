-- ##Title web-设置沟通/服务专员能力标签
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-设置沟通/服务专员能力标签
-- ##CallType[ExSql]

-- ##input dataGuid char[36] NOTNULL;服务对象guid，必填
-- ##input targetUserId char[36] NOTNULL;服务对象guid，必填
-- ##input type string[1] NOTNULL;档案模板guid，必填
-- ##input dataType string[1] NOTNULL;档案模板guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @flag1=(select case when exists(select 1 from coz_server2_sys_user_label where type='{type}' and user_id='{targetUserId}' and data_type='{dataType}' and data_guid='{dataGuid}' and del_flag='0') then '0' else '1' end)
;
insert into coz_server2_sys_user_label(guid,user_id,type,data_type,data_guid,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{targetUserId}' as user_id
,'{type}' as type
,'{dataType}' as data_type
,'{dataGuid}' as data_guid
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1'
limit 1
;