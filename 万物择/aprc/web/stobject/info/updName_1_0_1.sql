-- ##Title web-编辑姓名
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-编辑姓名
-- ##CallType[ExSql]

-- ##input objectGuid char[36] NOTNULL;机构名称guid，必填
-- ##input objName string[30] NULL;登录用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_target_object
set 
name='{objName}'
,update_by='{curUserId}'
,update_time=now()
where guid='{objectGuid}'
;
