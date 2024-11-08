-- ##Title 查询订单详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 查询订单详情
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填


-- ##output requestGuid char[36] 需求guid;需求guid
-- ##output requestPriceGuid char[36] 需求价格guid;需求价格guid
-- ##output categoryGuid char[36] 品类名称guid;品类名称guid
-- ##output demandUserId char[36] 需方用户id;需方用户id
-- ##output supplyUserId char[36] 供方用户id;供方用户id
-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output childOrderGuid char[36] 子订单guid;子订单guid
-- ##output cancelOrderGuid char[36] 订单取消guid;订单取消guid
-- ##output payStatus char[1] ;支付状态：0-待支付，1-支付失败，2-支付成功
-- ##output payFee int[>=0] ;支付状金额

select t.request_guid                                                                   as requestGuid
     , t.request_price_guid                                                             as requestPriceGuid
     , t.category_guid                                                                  as categoryGuid
     , demand_user_id                                                                   as demandUserId
     , supply_user_id                                                                   as supplyUserId
     , t.guid                                                                           as orderGuid
     , t.pay_fee                                                                        as payFee
     , t.pay_status                                                                     as payStatus
     , (select guid from coz_order where parent_guid = t.guid order by id desc limit 1) as childOrderGuid
     , sd_path_guid                                                                     as sdPathGuid
     , t2.guid                                                                          as cancelGuid
from coz_order t
         left join coz_order_cancel t2 on t.guid = t2.order_guid
where t.guid = '{orderGuid}'