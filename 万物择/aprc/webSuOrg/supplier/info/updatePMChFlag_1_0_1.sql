-- ##Title web-供应-修改需求范围变更阅读标志为已读
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-供应-修改需求范围变更阅读标志为已读
-- ##CallType[ExSql]

-- ##input supplierGuid char[36] NOTNULL;供方品类表guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_supplier
set read_pm_chflag='2'
,read_pm_chflag_time=now()
,update_by='{curUserId}'
,update_time=now()
where guid='{supplierGuid}' and read_pm_chflag='1'