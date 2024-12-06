-- ##Title app-供方-删除品类
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供方-删除品类
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input supplierGuid char[36] NOTNULL;品类guid，必填

update
coz_demand_request_supply t1
set t1.de_read_sudel_flag='1'
where t1.supplier_guid='{supplierGuid}' and t1.select_flag='0 'and t1.de_read_sudel_flag='0'
;
update coz_category_supplier 
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{supplierGuid}'
;