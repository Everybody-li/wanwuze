-- ##Title app-采购/供应-查询订单是否取消
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购/供应-查询订单是否取消
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output cancelFlag string[1] 0;订单取消标志（0：未取消，1：已取消）
-- ##output cancelReason string[200] 订单取消理由;订单取消理由
-- ##output cancelTime string[10] 00000000;订单取消时间（格式：00000000）

select
cancelFlag
,case when(cancelFlag='1') then concat('于[',(select left(create_time+0,8) from coz_order_cancel where order_guid='{orderGuid}' and del_flag),']关联方取消订单。现进入退货裁决，在【订单状态管理】中可见。') else '' end as cancelReason
,(select left(create_time+0,8) from coz_order_cancel where order_guid='{orderGuid}' and del_flag) as cancelTime
from
(
select
case when exists(select 1 from coz_order_cancel where order_guid='{orderGuid}' and del_flag='0' and cancel_object='3') then '1' else '0' end cancelFlag
)t
