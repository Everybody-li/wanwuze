-- ##Title app-采购-查询供方报价清单
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-查询供方报价清单
-- ##CallType[QueryData]

-- ##input requestGuid char[36] NOTNULL;订单guid，必填
-- ##input requestPriceGuid char[36] NOTNULL;需求供方报价guid，必填
-- ##input curUserId string[36] NOTNULL;需方用户id，必填

select
t.*
,t1.guid as logisRequestPriceGuid
,t1.request_supply_guid as logisRequestSupplyGuid
,case when (t1.supply_price>0) then cast(t1.supply_price/100 as decimal(18,2)) else cast(t.logisRequestSupplyPriceGuid1/100 as decimal(18,2)) end as logisticsFee
from
(
select 
t.guid as requestPriceGuid
,t2.guid as requestSupplyGuid
,case 
when (t.logistics_fee=0 and t1.supply_assign_rule_type=1) 
then 
(select logisRequestSupplyPriceGuid from (select a.guid as logisRequestSupplyPriceGuid,a.supply_price,(select count(1) from coz_order where del_flag='0' and pay_status='2' and category_guid=b.category_guid and supply_user_id=a.user_id) as orderNum,c.id as userId from coz_demand_request_price a left join coz_demand_request b on a.request_guid=b.guid left join sys_weborg_user c on a.user_id=c.guid where b.parent_guid='{requestGuid}' and a.del_flag='0'  and b.del_flag='0' and c.del_flag='0')t order by supply_price,orderNum,userId limit 1) 
when (t.logistics_fee=0 and t1.supply_assign_rule_type=2) 
then 
(select logisRequestSupplyPriceGuid from (select a.guid as logisRequestSupplyPriceGuid,rand() as idx from coz_demand_request_price a left join coz_demand_request b on a.request_guid=b.guid where b.parent_guid='{requestGuid}' and a.del_flag='0' and b.del_flag='0')t order by idx limit 1) 
when (t.logistics_fee=0 and t1.supply_assign_rule_type=0) 
then
'0.00'
else
t.logistics_fee
end as logisRequestSupplyPriceGuid1
,t.supply_company_name as supplyCompanyName
,t1.category_guid as categoryGuid
,t1.category_name as categoryName
,t1.category_img as categoryImg
,cast(t.supply_price/100 as decimal(18,2)) as supplyPrice
,case when (cattype_guid='43cabc5d-f1ce-11ec-bace-0242ac120003') then t.supply_price else (select if(plate_field_code in ('f00051','f00062') ,concat(cast(plate_field_value/100 as decimal(18,2)),ifnull(plate_field_value_remark,'')),plate_field_value) from coz_demand_request_price_plate where request_price_guid=t.guid and del_flag='0' and plate_field_code in ('f00051','f00062')  order by create_time desc limit 1) end as supplyPriceWithUpCase
,cast((t.supply_service_fee+t.demand_service_fee)/100 as decimal(18,2)) as serviceFee
,cast(t.tax_fee/100 as decimal(18,2)) as importTaxFee
,cast(t.logistics_insurance_fee/100 as decimal(18,2)) as logisticsInsuranceFee
,t.id
from  
coz_demand_request_price t
left join
coz_demand_request t1
on t.request_guid=t1.guid
left join 
coz_demand_request_supply t2
on t.request_supply_guid=t2.guid 
where 
t.request_guid='{requestGuid}' and t.guid='{requestPriceGuid}' and t.del_flag='0' and t2.price_status='3'
)t
left join
coz_demand_request_price t1
on t.logisRequestSupplyPriceGuid1=t1.guid
order by t.id desc
