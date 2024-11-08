-- ##Title 需求-查询需求价格信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 需求-查询需求价格信息
-- ##CallType[QueryData]

-- ##input requestSupplyGuid char[36] NOTNULL;需求供方guid，必填
-- ##input curUserId string[36] NOTNULL;需方用户id，必填

-- ##output unitFee int[>=0] 1;单价,即服务定价基数,单位分

-- ##output quantity int[>0] 1;购买数量

select 
t.guid
,t.request_supply_guid as requestSupplyGuid
,t.user_id as userId
,t.supply_service_fee as supplyServiceFee
,t.supply_service_fee_remark as supplyServiceFeeRemark
,t.demand_service_fee as demandServiceFee
,t.demand_service_fee_remark as demandServiceFeeRemark
,t.supply_price as supplyPrice
,t.tax_fee as taxFee
,t.total_fee as totalFee
,t.discount_fee as discountFee
,t.logistics_fee as logisticsFee
,t.logistics_insurance_fee as logisticsInsuranceFee
,unit_fee as unitFee
,t.quantity
from  
coz_demand_request_price t
where 
t.request_supply_guid='{requestSupplyGuid}' and t.de_read_invalid_flag='0' and t.del_flag='0'
