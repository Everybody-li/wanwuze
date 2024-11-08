-- ##Title web-删除字段内容
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除字段内容
-- ##CallType[ExSql]

-- ##input fdValueGuid char[36] NOTNULL;字段内容guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_model_fixed_data_value
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{fdValueGuid}'
;