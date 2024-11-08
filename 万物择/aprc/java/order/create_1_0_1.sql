-- ##Title 保存订单
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 保存订单
-- ##CallType[ExSql]

-- ##input guid char[36] NOTNULL;订单guid，必填
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径关联guid，必填
-- ##input parentGuid string[36] NULL;订单guid，非必填
-- ##input orderNo string[24] NOTNULL;订单编号，必填
-- ##input requestGuid char[36] NOTNULL;需求guid，必填
-- ##input requestPriceGuid char[36] NOTNULL;需求报价guid，必填
-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input demandUserId char[36] NOTNULL;需方用户id，必填
-- ##input supplyUserId char[36] NOTNULL;供方用户id，必填
-- ##input logisticsFee int[>=0] NOTNULL;物流费用，必填
-- ##input logisticsInsuranceFee int[>=0] NOTNULL;物流费用，必填
-- ##input demandServiceFee int[>=0] NOTNULL;需方服务费用，必填
-- ##input demandServiceFeeRemark string[100] NULL;需方服务费用说明，非必填
-- ##input supplyServiceFee int[>=0] NOTNULL;供方服务费用，必填
-- ##input supplyServiceFeeRemark string[100] NULL;供方服务费用说明，非必填
-- ##input taxFee int[>=0] NOTNULL;税费，必填
-- ##input discountFee int[>=0] NOTNULL;优惠金额，必填
-- ##input supplyFee int[>=0] NOTNULL;产品费用(供方报价)，必填
-- ##input invoiceTitle string[15] NULL;发票抬头，非必填
-- ##input invoiceType char[1] NULL;发票类型，非必填
-- ##input invoiceCompany string[35] NULL;开票单位，非必填
-- ##input invoiceTaxNumber string[50] NULL;纳税识别号，非必填
-- ##input invoiceAddrPhone string[100] NULL;地址、电话，非必填
-- ##input invoiceBankAccount string[100] NULL;开户行及账号，非必填
-- ##input needDeliverFlag string[1] NOTNULL;是否需要发货
-- ##input payType string[1] NOTNULL;支付类型（支付类型：0-未唤起支付,1-微信，2-支付宝），必填
-- ##input payFee int[>=0] NOTNULL;支付费用，必填
-- ##input totalFee int[>=0] NOTNULL;应付费用，必填
-- ##input curUserId string[36] NULL;登录用户id，必填

INSERT INTO coz_order
(guid,sd_path_guid,parent_guid,all_parent_id,order_no,request_guid,request_price_guid,category_guid,demand_user_id,supply_user_id,logistics_fee,logistics_insurance_fee,demand_service_fee,demand_service_fee_remark,supply_service_fee,supply_service_fee_remark,tax_fee,discount_fee,supply_fee,invoice_title,invoice_type,invoice_company,invoice_tax_number,invoice_addr_phone,invoice_bank_account,pay_fee,total_fee,pay_type,need_deliver_flag,del_flag,create_by,create_time,update_by,update_time) 
select 
'{guid}' as guid
,'{sdPathGuid}' as sd_path_guid
,'{parentGuid}' as parent_guid
,(select CONCAT(ifnull(CONCAT(all_parent_id,','),''),id) from coz_order where guid='{parentGuid}') as all_parent_id
,'{orderNo}' as order_no
,'{requestGuid}' as request_guid
,'{requestPriceGuid}' as request_price_guid
,'{categoryGuid}' as category_guid
,'{demandUserId}' as demand_user_id
,'{supplyUserId}' as supply_user_id
,{logisticsFee} as logistics_fee
,{logisticsInsuranceFee} as logistics_insurance_fee
,{demandServiceFee} as demand_service_fee
,'{demandServiceFeeRemark}' as demand_service_fee_remark
,{supplyServiceFee} as supply_service_fee
,'{supplyServiceFeeRemark}' as supply_service_fee_remark
,{taxFee} as tax_fee
,{discountFee} as discount_fee
,{supplyFee} as supplyFee
,'{invoiceTitle}' as invoice_title
,'{invoiceType}' as invoice_type
,'{invoiceCompany}' as invoice_company
,'{invoiceTaxNumber}' as invoice_tax_number
,'{invoiceAddrPhone}' as invoice_addr_phone
,'{invoiceBankAccount}' as invoice_bank_account
,'{payFee}' as payFee
,'{totalFee}'  as total_fee
,'{payType}' as payType
,'{needDeliverFlag}' as need_deliver_flag
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}'  as update_by
,now() as update_time
;