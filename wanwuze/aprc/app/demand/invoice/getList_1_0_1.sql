-- ##Title app-采购-查询发票信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-06-11
-- ##Describe app-采购-查询发票信息
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id

select
guid as invoiceGuid
,case when(title='1') then '个人' else '公司' end as invoiceTitle
,case when(type='1') then '普通发票' else '增值税专用发票' end as invoiceType
,company as invoiceCompany
,tax_number as invoiceTaxNumber
,addr_phone as invoiceAddrPhone
,bank_acc as invoiceBankAccout
from
coz_user_invoice
where 
user_id='{curUserId}' and del_flag='0'