-- ##Title 保存用户招聘需求
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 保存用户招聘需求
-- ##CallType[ExSql]

-- ##input deRequestGuid string[36] NOTNULL;应聘信息guid，必填
-- ##input fdGuid char[36] NOTNULL;固化字段guid，必填
-- ##input fdCode string[6] NOTNULL;固化字段code，必填
-- ##input fdName string[20] NOTNULL;字段名称，必填
-- ##input fdValue string[20] NOTNULL;固化字段值，必填

insert into coz_chat_supply_request_detail(guid,de_request_guid,fd_guid,fd_code,fd_name,fd_value,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{deRequestGuid}' as deRequestGuid
,'{fdGuid}' as fd_guid
,'{fdCode}' as fd_code
,'{fdName}'as fd_name
,'{fdValue}' as fd_value
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now()as update_time
;
