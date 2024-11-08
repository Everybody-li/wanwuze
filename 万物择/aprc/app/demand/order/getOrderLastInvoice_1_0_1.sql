-- ##Title app-采购-查询最近一次使用的发票信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-06-11
-- ##Describe app-采购-查询最近一次使用的发票信息
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output invoiceTitle string[15] 发票抬头;发票抬头
-- ##output invoiceType enum[1,2] 1;发票类型(1-普通发票，2-增值税专用发票)
-- ##output invoiceCompany string[30] 开票单位;开票单位
-- ##output invoiceTaxNumber string[50] 纳税识别号;纳税识别号
-- ##output invoiceAddrPhone string[40] 地址、电话;地址、电话
-- ##output invoiceBankAccout string[40] 开户行及账号;开户行及账号

select 
*
from
(
select
invoice_title as invoiceTitle
,invoice_type as invoiceType
,invoice_company as invoiceCompany
,invoice_tax_number as invoiceTaxNumber
,invoice_addr_phone as invoiceAddrPhone
,invoice_bank_account as invoiceBankAccout
from
coz_order
where 
demand_user_id='{curUserId}' and del_flag='0'
order by id desc
limit 1
)t
where 
invoiceTaxNumber<>''