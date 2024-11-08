-- ##Title web-供应-查询订单详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-供应-查询订单详情
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;供方用户id，必填

-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output categoryImg string[50] 品类图片;品类图片
-- ##output categoryalias string[50] 品类别名;品类别名，多个逗号隔开
-- ##output orderNo string[24] 采购编号;采购编号
-- ##output orderTime string[10] 订单创建日期;订单创建日期（格式：0000-00-00）
-- ##output orderFee decimal[>=0] 10.00;订单金额/元
-- ##output categoryFee decimal[>=0] 10.00;应收金额/元
-- ##output discountFee decimal[>=0] 10.00;优惠金额/元
-- ##output invoiceType int[>=0] 1;发票类型（1：普通发票，2：增值税专用发票）
-- ##output invoiceTitle string[20] 发票抬头;发票抬头
-- ##output invoiceCompany string[20] 发票单位;发票单位
-- ##output invoiceTaxNumber string[20] 纳税识别号;纳税识别号
-- ##output invoiceAddrPhone string[20] 发票地址电话;发票地址电话
-- ##output invoiceBankAccount string[20] 发票开户行及账号;发票开户行及账号
-- ##output needDeliverFlag int[>=0] 1;是否需要发货（0-不需要，1-需要，即是否有物流）

select 
t.guid as orderGuid
,t1.name as categoryName
,t1.img as categoryImg
,t1.alias as categoryAlias
,t.order_no as orderNo
,left(t.create_time,10) as orderTime
,CAST((t.supply_fee/100) AS decimal(18,2)) as orderFee
,(CAST((t.supply_fee/100) AS decimal(18,2))-CAST((t.discount_fee/100) AS decimal(18,2))) as supplyFee
,CAST((t.discount_fee/100) AS decimal(18,2)) as discountFee
,t.invoice_type as invoiceType
,t.invoice_title as invoiceTitle
,t.invoice_company as invoiceCompany
,t.invoice_tax_number as invoiceTaxNumber
,t.invoice_addr_phone as invoiceAddrPhone
,t.invoice_bank_account as invoiceBankAccount
,t.need_deliver_flag as needDeliverFlag
,'' as brandName
,t3.supply_company_name as supplyCompanyName
,t3.request_guid as requestGuid
,t3.guid as requestPriceGuid
,t3.request_supply_guid as requestSupplyGuid
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