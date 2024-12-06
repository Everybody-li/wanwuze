-- ##Title web-删除型号定价-按型号名称_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除型号定价-按型号名称_1_0_1
-- ##CallType[ExSql]

-- ##input serviceFeeMnGuid string[50] NOTNULL;型号名称定价guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_service_fee_mn
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where
guid='{serviceFeeMnGuid}'
;