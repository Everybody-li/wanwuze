-- ##Title web-服务应用信息-材料管理-添加材料
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-服务应用信息-材料管理-添加材料
-- ##CallType[ExSql]

-- ##input fileName string[30] NOTNULL;档案模板guid，必填
-- ##input type string[1] NOTNULL;档案模板guid，必填
-- ##input fileValue string[100] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


insert into coz_serve2_pfelang(guid,type,file_name,file_value,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{type}' as type
,'{fileName}' as field_name
,'{fileValue}' as field_value
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
