
-- ##Title 需求-根据品类guid和需求guid查询web供方列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 需求-查询品类guid和需求guid查询web供方列表
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input priceMode string[1] NOTNULL;报价模式，必填
-- ##input requestGuid char[36] NULL;供方品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

# 按单模式，根据品类guid和需求guid查询未重复匹配的供方
select t1.guid
     , t1.user_id           as userId
     , t2.user_name         as userName
     , t2.phonenumber       as userPhone
     , t1.range_flag        as rangeFlag
     , t1.user_price_mode   as userPriceMode
     , t1.accpet_order_flag as acceptOrderFlag
from coz_category_supplier t1
         inner join sys_weborg_user t2 on t1.user_id = t2.guid
         left join coz_demand_request_supply t3 on t3.supplier_guid = t1.guid and t3.request_guid = '{requestGuid}'
where '{priceMode}' = '1'
  and t1.category_guid = '{categoryGuid}'
  and t1.del_flag = '0'
  and t2.status = '0'
  and t1.del_flag = '0'
  and t3.guid is null
union all
# 型号模式，根据品类guid和需求guid及供方品类型号guid查询未重复匹配的供方
select t1.guid
     , t1.user_id           as userId
     , t2.user_name         as userName
     , t2.phonenumber       as userPhone
     , t1.range_flag        as rangeFlag
     , t1.user_price_mode   as userPriceMode
     , t1.accpet_order_flag as acceptOrderFlag
from coz_category_supplier t1
         inner join sys_weborg_user t2 on t1.user_id = t2.guid
         left join coz_demand_request_supply t3 on t3.supplier_guid = t1.guid and t3.request_guid = '{requestGuid}'
         left join coz_category_supplier_model t4 on t4.supplier_guid = t3.supplier_guid and t4.guid = t3.model_guid
where '{priceMode}' = '2'
  and t1.category_guid = '{categoryGuid}'
  and t1.del_flag = '0'
  and t2.status = '0'
  and t1.del_flag = '0'
  and t3.guid is null
;
