-- ##Title app-供应-查询订单状态详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-查询订单状态详情
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NULL;供方用户id，必填
-- ##input curUserId string[36] NULL;供方用户id，必填

-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output orderTime string[10] 0000-00-00;订单状态发生时间（格式：0000年-00月-00日）
-- ##output orderStatus string[10] 最新订单状态;最新订单状态（1：需方取消订单--需方操作，2：供方取消订单--供方操作，3：订单交易仲裁--系统操作，4：供方处理完成--供方操作，5：需方验收通过--需方操作，6：需方退货申请--需方操作，7：需方退货完成--需方操作，8：供方验收不通过--供方操作，9：供方验收通过---供方操作）

select 
t.order_guid as orderGuid
,concat(left(t.create_time,4),'年',right(left(t.create_time,7),2),'月',right(left(t.create_time,10),2),'日') as orderTime
,t.status as orderStatus
from  
coz_order_operation_log t
left join
coz_order t1
on t.order_guid=t1.guid
where 
t1.supply_user_id='{curUserId}' and t1.del_flag='0' and t1.guid='{orderGuid}'
order by t.create_time desc