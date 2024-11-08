-- ##Title app-采购-删除发票信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-删除发票信息
-- ##CallType[ExSql]

-- ##input invoiceGuid char[36] NOTNULL;发票id
-- ##input curUserId string[36] NOTNULL;用户id

update coz_user_invoice 
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{invoiceGuid}'