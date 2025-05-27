-- ##Title app-采购-查询需求供应的供方信息列表(有报价的供方)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-查询需求供应的供方信息列表(有报价的供方)
-- ##CallType[QueryData]

-- ##input requestGuid char[36] NOTNULL;订单guid，必填
-- ##input supplyCompanyName string[20] NULL;供方主体（模糊搜索），非必填
-- ##input brandName string[20] NULL;供方品牌名称（模糊搜索），非必填
-- ##input orderBy string[20] NULL;采购费用（total_fee desc：降序,total_fee ：升序,distance desc：降序，distance：升序），必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;需方用户id，必填

-- ##output reqSupplyGuid char[36] 供需配对guid;供需配对guid
-- ##output requestPriceGuid char[36] 供方报价guid;供方报价guid
-- ##output supplyCompanyName string[24] 供应主体;供应主体
-- ##output distance int[>=0] 100;供方距离需方直线距离
-- ##output brandName string[24] 品牌名称;品牌名称
-- ##output supplyPrice int[>=0] 10.00;产品费用（单位为分，app除以100，并保留2位小数）
-- ##output serviceFee int[>=0] 10.00;服务费用/元（单位为分，app除以100，并保留2位小数）
-- ##output importTaxFee int[>=0] 10.00;关税金额/元（单位为分，app除以100，并保留2位小数）
-- ##output logisticsFee int[>=0] 10.00;物流费用/元（单位为分，app除以100，并保留2位小数）
-- ##output logisticsInsuranceFee int[>=0] 10.00;物流保价费用（单位为分，app除以100，并保留2位小数）

select
*
from
(
select 
t.guid as requestPriceGuid
,t2.guid as reqSupplyGuid
,t.supply_company_name as supplyCompanyName
,t.distance
,ifnull((select a.plate_field_value from coz_demand_request_price_plate a left join coz_model_plate_field_formal b on a.plate_field_formal_guid=b.guid left join coz_model_fixed_data c on b.name=c.code where c.code='f00052' and a.del_flag='0' and a.status='1' and a.request_price_guid=t.guid limit 1),'') as brandName
,cast(t.supply_price/100 as decimal(18,2)) as supplyPrice
# ,cast((t.supply_service_fee+t.demand_service_fee)/100 as decimal(18,2)) as serviceFee
,cast((t.supply_service_fee+t.demand_service_fee)  as decimal(18,2)) as serviceFee
,cast(t.tax_fee/100 as decimal(18,2)) as importTaxFee
,cast(t.logistics_fee/100 as decimal(18,2)) as logisticsFee
,cast(t.logistics_insurance_fee/100 as decimal(18,2)) as logisticsInsuranceFee
,t.total_fee  as total_fee
from  
coz_demand_request_price t
left join
coz_demand_request t1
on t.request_guid=t1.guid
left join 
coz_demand_request_supply t2
on t.request_supply_guid=t2.guid 
where 
t.request_guid='{requestGuid}' and t.del_flag='0' and t2.price_status='3'
)t
where 
(brandName like '%{brandName}%' or '{brandName}'='')
order by {orderBy}
Limit {compute:[({page}-1)*{size}]/compute},{size};