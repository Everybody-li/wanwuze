-- ##Title web-供应-结算账号-新增
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-供应-结算账号-新增
-- ##CallType[ExSql]

-- ##input orgGuid char[36] NOTNULL;需求guid，必填
-- ##input bankUserName string[40] NOTNULL;需求guid，必填
-- ##input bankName string[40] NOTNULL;需求guid，必填
-- ##input bankUserNo string[20] NOTNULL;需求guid，必填
-- ##input bankAddr string[100] NOTNULL;需求guid，必填
-- ##input curUserId string[36] NOTNULL;需方用户id，必填

delete from coz_org_bank where user_id='{curUserId}'
;
insert into coz_org_bank (guid,org_guid,user_id,bank_user_name,bank_name,bank_user_no,bank_addr,del_flag,create_by,create_time,update_by,update_time)
value (uuid(),'{orgGuid}','{curUserId}','{bankUserName}','{bankName}','{bankUserNo}','{bankAddr}','0','{curUserId}',now(),'{curUserId}',now())
;
insert into coz_org_bank_log (guid,org_guid,user_id,bank_user_name,bank_name,bank_user_no,bank_addr,del_flag,create_by,create_time,update_by,update_time)
value (uuid(),'{orgGuid}','{curUserId}','{bankUserName}','{bankName}','{bankUserNo}','{bankAddr}','0','{curUserId}',now(),'{curUserId}',now())
;
update 
coz_category_supplier t3
inner join
coz_category_supplier_model t4
on t3.guid=t4.supplier_guid
inner join
coz_category_supplier_model_price t5
on t4.guid=t5.model_guid
set t5.bank_user_name='{bankUserName}'
,t5.bank_name='{bankName}'
,t5.bank_user_no='{bankUserNo}'
,t5.bank_addr='{bankAddr}'
,t5.update_by='{curUserId}'
,t5.update_time=now()
where t3.user_id='{curUserId}'
;
update coz_demand_request_price t7
inner join
coz_demand_request t6
on t6.guid=t7.request_guid
set t7.bank_user_name='{bankUserName}'
,t7.bank_name='{bankName}'
,t7.bank_user_no='{bankUserNo}'
,t7.bank_addr='{bankAddr}'
,t7.update_by='{curUserId}'
,t7.update_time=now()
where t6.done_flag='0' and t6.cancel_flag='0' and t7.user_id='{curUserId}'