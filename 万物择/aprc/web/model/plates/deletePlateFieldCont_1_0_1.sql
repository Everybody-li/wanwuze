-- ##Title web-删除/移除字段内容（固化库/自建库）
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除/移除字段内容（固化库/自建库）
-- ##CallType[ExSql]

-- ##input fieldContentGuid char[36] NOTNULL;字段名称内容guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_model_plate_field_content 
set del_flag='2' 
,publish_flag='0'
,update_by='{curUserId}'
,update_time=now()
where guid='{fieldContentGuid}'
;
