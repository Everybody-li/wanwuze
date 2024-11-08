-- ##Title 批量保存需求供方及供方报价
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 批量保存需求供方
-- ##CallType[ExSql]

-- ##input requestPriceGuid char[36] NOTNULL;需求报价guid，必填 
-- ##input requestGuid char[36] NOTNULL;需求guid，必填
-- ##input requestSupplyGuid char[36] NOTNULL;需求供方guid，必填
-- ##input userId char[36] NOTNULL;供方用户guid，必填
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
-- ##input unitFee int[>=0] NOTNULL;单价
-- ##input quantity int[>=0] NOTNULL;数量

insert into coz_demand_request_price(guid, request_guid, request_supply_guid, user_id, model_guid, model_name,
                                     bank_user_name, bank_name, bank_user_no, bank_addr, supply_company_name,
                                     supply_price, supply_price_time, unit_fee, quantity, logistics_fee,
                                     logistics_insurance_fee,
                                     demand_service_fee, demand_service_fee_remark, supply_service_fee,
                                     supply_service_fee_remark, tax_fee, discount_fee, selected_flag, distance,
                                     total_fee, del_flag, create_by, create_time, update_by, update_time)
select '{requestPriceGuid}'       as guid
     , '{requestGuid}'            as request_guid
     , '{requestSupplyGuid}'      as request_supply_guid
     , '{userId}'                 as user_id
     , ''                         as model_guid
     , ''                         as model_name
     , '{bankUserName}'           as bank_user_name
     , '{bankName}'               as bank_name
     , '{bankUserNo}'             as bank_user_no
     , '{bankAddr}'               as bank_addr
     , '{supplyCompanyName}'      as supply_company_name
     , '{supplyPrice}'            as supply_price
     , now()                      as supply_price_time
     , {unitFee}                  as unitFee
     , {quantity}                 as quantity
     , '{logisticsFee}'           as logistics_fee
     , '{logisticsInsuranceFee}'  as logistics_insurance_fee
     , '{demandServiceFee}'       as demand_service_fee
     , '{demandServiceFeeRemark}' as demand_service_fee_remark
     , '{supplyServiceFee}'       as supply_service_fee
     , '{supplyServiceFeeRemark}' as supply_service_fee_remark
     , '{taxFee}'                 as tax_fee
     , 0                          as discount_fee
     , '0'                        as selected_flag
     , {distance}                 as distance
     , {totalFee}                 as total_fee
     , '0'                        as del_flag
     , '{curUserId}'              as create_by
     , now()                      as create_time
     , '{curUserId}'              as update_by
     , now()                      as update_time
from coz_model_fixed_data
where not exists(select 1
                 from coz_demand_request_price
                 where request_guid = '{requestGuid}'
                   and request_supply_guid = '{requestSupplyGuid}'
                   and del_flag = '0')
limit 1
;
update coz_demand_request_supply
set price_status=3
  , price_time=now()
  , de_read_flag='1'
  , update_by='{curUserId}'
  , update_time=now()
where guid = '{requestSupplyGuid}'
;

# 组织(服务)模块3.0相关,记录品类交易状态 -- 开始
set @demandSysUserGuid = '';
set @supplySysUserGuid = '';
set @catMode ={url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\CatDealStatus\getCatModeByReqGuid_1_0_1&requestGuid={requestGuid}&DBC=w_a]/url};

# 查询需方用户的对接专员
select t2.user_guid as sysUserGuid
into @demandSysUserGuid
from coz_demand_request t1
         inner join
     coz_server3_sys_user_dj_bind t2
     on t1.user_id = t2.binded_user_id
where t1.guid = '{requestGuid}'
  and t1.del_flag = '0'
  and t2.user_type = '1';

# 查询供方用户的对接专员
select user_guid as sysUserGuid
into @supplySysUserGuid
from coz_server3_sys_user_dj_bind
where binded_user_id = '{userId}'
  and user_type = '2';

# 审批模式:更新品类交易状态为订单验收通过--仅审批模式更新该状态,交易模式是一对多,不处理
update coz_server3_cate_dealstatus_statistic
set biz_guid            = '{requestPriceGuid}'
  , update_by='{curUserId}'
  , update_time=now()
  , dstatus             = 316
  , supply_user_id='{userId}'
  , supply_user_name=(select user_name from coz_demand_request_supply where guid = '{requestSupplyGuid}')
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
where biz_guid = '{requestGuid}'
  and @catMode = 3
;


