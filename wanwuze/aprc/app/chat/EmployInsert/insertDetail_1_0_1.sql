-- ##Title app-应聘-应聘方式管理-目标工作管理-创建工作信息-新增子表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 表名：coz_chat_employ_detail
-- ##CallType[ExSql]

-- ##input recruitGuid string[36] NOTNULL;应聘信息guid，必填
-- ##input fdGuid char[36] NOTNULL;固化字段guid，必填
-- ##input fdCode string[6] NOTNULL;固化字段code，必填
-- ##input fdValue string[20] NOTNULL;固化字段值，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_chat_employ_detail(guid,employ_guid,fd_guid,fd_code,fd_value,create_by,create_time,update_by,update_time,del_flag)
select
uuid() as guid
,'{recruitGuid}' as recruit_guid
,'{fdGuid}' as fd_guid
,'{fdCode}' as fd_code
,'{fdValue}' as fd_value
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now()as update_time
,'0' as del_flag
;
