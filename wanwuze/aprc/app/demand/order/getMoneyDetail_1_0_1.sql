-- ##Title app-采购-查询订单采购金额详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-查询订单采购金额详情
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;供方用户id，必填



select 
t.guid as orderGuid
,t1.guid as categoryGuid
,t1.name as categoryName
,t1.img as categoryImg
,t1.alias as categoryAlias
,t.order_no as orderNo
,left(t.create_time,10) as orderTime
,CAST((t.total_fee/100) AS decimal(18,2)) as totalFee
,CAST((t.supply_fee/100) AS decimal(18,2)) as supplyPrice
,CAST((t.discount_fee/100) AS decimal(18,2)) as discountFee
,CAST((t.logistics_fee/100) AS decimal(18,2)) as logisticFee
,CAST((t.demand_service_fee/100) AS decimal(18,2)) as demandServiceFee
,CAST((t.logistics_insurance_fee/100) AS decimal(18,2)) as logisticInsuraceFee
,CAST((t.tax_fee/100) AS decimal(18,2)) as taxFee
,t.request_guid as requestGuid
,t3.request_supply_guid as requestSuppyGuid
,ifnull((select a.plate_field_value from coz_demand_request_price_plate a left join coz_model_plate_field_formal b on a.plate_field_formal_guid=b.guid left join coz_model_fixed_data c on b.name=c.code where c.code='f00052' and a.del_flag='0' and a.status='1' and a.request_price_guid=t3.guid limit 1),'') as brandName
,t3.supply_company_name as supplyCompanyName
,t3.guid as requestPriceGuid
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