-- ##Title 查询订单仲裁详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 查询订单仲裁详情
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NULL;订单guid,必填

-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output judgeGuid char[36] 裁决guid;裁决guid
-- ##output judgeResult int[>=0] 1;裁决结果
-- ##output orderAmount int[>=0] 1;订单实付金额
-- ##output bizType int[>=0] 1;业务类型:1-取消订单,2-订单退货
-- ##output refundGuid char[36] 订单退货guid;订单退货guid
-- ##output cancelGuid char[36] 订单取消guid;订单取消guid

select 
t.order_guid as orderGuid
,t.guid as judgeGuid
,t.result as judgeResult
,t3.pay_fee as orderAmount
,t.biz_type as bizType
,t1.guid as refundGuid
,t2.guid as cancelGuid
from 
coz_order_judge t
left join 
coz_order_refund t1
on t.biz_guid=t1.guid 
left join 
coz_order_cancel t2
on t.biz_guid=t2.guid 
left join 
coz_order t3 
on t.order_guid=t3.guid 
left join 
coz_category_info t4
on t3.category_guid=t4.guid 
where 
t.order_guid='{orderGuid}'and t.del_flag='0'

