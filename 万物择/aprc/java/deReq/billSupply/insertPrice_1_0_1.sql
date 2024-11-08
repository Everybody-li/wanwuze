-- ##Title 批量保存需求供方及供方报价
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 批量保存需求供方
-- ##CallType[ExSql]

-- ##input requestPriceGuid char[36] NOTNULL;需求报价guid，必填 
-- ##input requestGuid char[36] NOTNULL;需求guid，必填
-- ##input requestSupplyGuid char[36] NOTNULL;需求供方guid，必填
-- ##input bankUserName string[40] NOTNULL;开户账户名称，必填
-- ##input bankUserNo string[20] NOTNULL;开户银行账号，必填
-- ##input bankAddr string[100] NOTNULL;开户银行地址，必填
-- ##input bankName string[40] NOTNULL;开户银行，必填 
-- ##input supplyCompanyName string[50] NOTNULL;供应主体，必填
-- ##input supplyPrice string[50] NOTNULL;供方报价费用,人民币，单位分，必填
-- ##input logisticsFee string[50] NOTNULL;物流费用，必填
-- ##input logisticsInsuranceFee string[50] NOTNULL;物流保价费用，必填
-- ##input demandServiceFee string[50] NOTNULL;需方服务费用，必填
-- ##input demandServiceFeeRemark string[100] NOTNULL;需方服务费用说明，必填
-- ##input supplyServiceFee string[50] NOTNULL;供方服务费用，必填
-- ##input supplyServiceFeeRemark string[100] NOTNULL;供方服务费用说明，必填
-- ##input taxFee string[50] NOTNULL;关税，必填  
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input distance int[>=0] NOTNULL;关税，必填  
-- ##input totalFee int[>=0] NOTNULL;关税，必填  

insert into coz_demand_request_supply_serve2_source(guid,request_guid,request_supply_guid,aprice_uc_guid,aprice_staff_user_id,request_time,price_time)
select
uuid()
,'{requestGuid}'
,'{requestSupplyGuid}' as request_supply_guid
,t3.guid
,t3.user_id
,t4.create_time
,now()
from
coz_server2_sys_user_category t3
inner join
coz_demand_request t4
on t3.category_guid=t4.category_guid
where 
t4.guid='{requestGuid}' and t3.del_flag='0' and t4.del_flag='0' and not exists(select 1 from coz_demand_request_price where request_guid='{requestGuid}' and request_supply_guid='{requestSupplyGuid}' and del_flag='0')
limit 1
;
insert into coz_demand_request_price(guid,request_guid,request_supply_guid,user_id,model_guid,model_name,bank_user_name,bank_name,bank_user_no,bank_addr,supply_company_name,supply_price,supply_price_time,logistics_fee,logistics_insurance_fee,demand_service_fee,demand_service_fee_remark,supply_service_fee,supply_service_fee_remark,tax_fee,discount_fee,selected_flag,distance,total_fee,del_flag,create_by,create_time,update_by,update_time)
select
'{requestPriceGuid}' as guid
,'{requestGuid}' as request_guid
,'{requestSupplyGuid}' as request_supply_guid
,'{userId}' as user_id
,'' as model_guid
,'' as model_name
,'{bankUserName}' as bank_user_name
,'{bankName}' as bank_name
,'{bankUserNo}' as bank_user_no
,'{bankAddr}' as bank_addr
,'{supplyCompanyName}' as supply_company_name
,'{supplyPrice}' as supply_price
,now() as supply_price_time
,'{logisticsFee}' as logistics_fee
,'{logisticsInsuranceFee}' as logistics_insurance_fee
,'{demandServiceFee}' as demand_service_fee
,'{demandServiceFeeRemark}' as demand_service_fee_remark
,'{supplyServiceFee}' as supply_service_fee
,'{supplyServiceFeeRemark}' as supply_service_fee_remark
,'{taxFee}' as tax_fee
,0 as discount_fee
,'0' as selected_flag
,{distance} as distance
,{totalFee} as total_fee
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_model_fixed_data
where
not exists(select 1 from coz_demand_request_price where request_guid='{requestGuid}' and request_supply_guid='{requestSupplyGuid}' and del_flag='0')
limit 1
;
update coz_demand_request_supply
set price_status=3
,price_time=now()
,de_read_flag='1'
where guid='{requestSupplyGuid}'
;
delete from coz_biz_city_code_temp where biz_guid='{requestSupplyGuid}'
;