-- ##Title app-供应-按单-查询符合供需配对的需求列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-按单-查询符合供需配对的需求列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input sdPathGuid string[36] NOTNULL;采购供应路径guid，必填
-- ##input priceStatus int[>=0] NOTNULL;供方报价状态（1：未报价，2-拒绝报价，3-已报价），必填
-- ##input supplierGuid char[36] NOTNULL;供方品类表guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


select t2.guid                  as requestSupplyGuid
     , t3.guid                  as requestPriceGuid
     , t2.request_guid          as requestGuid
     , t1.category_guid         as categoryGuid
     , t1.category_img          as categoryImg
     , t1.category_name         as categoryName
     , t1.category_alias        as categoryAlias
     , t2.price_status          as PriceStatus
     , left(t2.create_time, 19) as reqCreateTime
     , left(t2.price_time, 19)  as PriceTime
     , t1.done_flag             as doneFlag
     , t1.cancel_flag           as reqCancelFlag
     , t2.model_guid            as modelGuid
from coz_demand_request t1
         inner join
     coz_demand_request_supply t2
     on t2.request_guid = t1.guid
         left join
     coz_demand_request_price t3
     on t2.guid = t3.request_supply_guid
where t2.supplier_guid = '{supplierGuid}'
  and t2.del_flag = '0'
  and t2.price_status = '{priceStatus}'
  and t1.sd_path_guid = '{sdPathGuid}'
  and t1.cancel_flag = '0'
  and t1.done_flag = '0'
order by t1.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};

