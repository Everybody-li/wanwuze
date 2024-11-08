-- ##Title app-采购-新增发票信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 新增发票
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;用户id
-- ##input title string[15] NOTNULL;发票抬头
-- ##input type string[10] NOTNULL;发票类型：1-普通发票，2-增值税专用发票
-- ##input company string[30] NOTNULL;开票单位
-- ##input taxNumber string[50] NOTNULL;纳税识别号
-- ##input addrPhone string[40] NOTNULL;地址、电话
-- ##input bankAcc string[60] NOTNULL;开户行及账号



insert into coz_user_invoice (guid,user_id,title,type,company,tax_number,addr_phone,bank_acc,del_flag,create_by,create_time,update_by,update_time)
value (uuid(),'{curUserId}','{title}','{type}','{company}','{taxNumber}','{addrPhone}','{bankAcc}','0','{curUserId}',now(),'{curUserId}',now())
