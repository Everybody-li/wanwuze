-- ##Title web-采购查询订单详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-采购查询订单详情
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
t.guid as orderGuid
,t1.name as categoryName
,t1.img as categoryImg
,t1.alias as categoryAlias
,t.order_no as orderNo
,left(t.create_time,10) as orderCreateDate
,(CAST((t.supply_fee/100) AS decimal(18,2))+CAST((t.demand_service_fee/100) AS decimal(18,2))+CAST((t.tax_fee/100) AS decimal(18,2))+CAST((t.logistics_fee/100) AS decimal(18,2))) as shouldPayFee
,CAST((t.discount_fee/100) AS decimal(18,2)) as discountFee
,(CAST((t.supply_fee/100) AS decimal(18,2))+CAST((t.demand_service_fee/100) AS decimal(18,2))+CAST((t.tax_fee/100) AS decimal(18,2))+CAST((t.logistics_fee/100) AS decimal(18,2))-CAST((t.discount_fee/100) AS decimal(18,2))) as payFee
,t.invoice_type as invoiceType
,t.invoice_title as invoiceTitle
,t.invoice_company as invoiceCompany
,t.invoice_tax_number as invoiceTaxNumber
,t.invoice_addr_phone as invoiceAddrPhone
,t.invoice_bank_account as invoiceBankAccount
,t.need_deliver_flag as needDeliverFlag
from  
coz_order t
left join 
coz_category_info t1
on t.category_guid=t1.guid 
left join 
coz_demand_request t2
on t.request_guid=t2.guid
left join 
coz_demand_request_price t3
on t.request_price_guid=t3.guid
where 
t.guid='{orderGuid}' and t.del_flag='0'

