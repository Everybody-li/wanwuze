-- ##output judgeGuid char[36] 仲裁guid;仲裁guid
-- ##output orderNo string[24] 采购编号;采购编号
-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output orderRefundGuid char[36] 订单退货guid;订单退货guid
-- ##output orderCancelGuid char[36] 订单取消guid;订单取消guid
-- ##output orderTime string[10] 订单日期;订单日期（格式：0000-00-00）
-- ##output categoryGuid char[36] 品类guid;品类guid
-- ##output categoryImg string[50] 品类图片;品类图片
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output categoryalias string[50] 品类别名;品类别名，多个逗号隔开
-- ##output refundPayTime string[50] 退款时间(格式：00000000)
-- ##output refundPayFlag string[1] 1;退款支付标志(0：未支付，1：已支付)
-- ##output refundPayReadFlag string[1] 1;退款支付阅读标志(1：未读，1-已读)

PREPARE q1 FROM '
select
*
from
(
select 
t.guid as judgeGuid
,t3.order_no as orderNo
,t.order_guid as orderGuid
,t1.guid as orderRefundGuid
,'''' as orderCancelGuid
,left(t3.create_time,10) as orderTime
,t4.guid as categoryGuid
,t4.img as categoryImg
,t4.name as categoryName
,t4.alias as categoryAlias
,ifnull(left(t1.refund_pay_time+0,8),left(t1.refund_pay_time+0,8)) as refundPayTime
,t1.refund_pay_flag as refundPayFlag
,ifnull(t1.refund_pay_read_flag,t1.refund_pay_read_flag) as refundPayReadFlag
,t3.id
from 
coz_order_judge t
left join 
coz_order_refund t1
on t.biz_guid=t1.guid 
left join 
coz_order t3 
on t.order_guid=t3.guid 
left join 
coz_category_info t4
on t3.category_guid=t4.guid 
where 
t3.demand_user_id=''{curUserId}'' and t.result<>''3'' and t3.parent_guid='''' and t3.sd_path_guid=''{sdPathGuid}'' and (t.biz_type=''2'')
union all
select 
t.guid as judgeGuid
,t3.order_no as orderNo
,t.order_guid as orderGuid
,'''' as orderRefundGuid
,t1.guid as orderCancelGuid
,left(t3.create_time,10) as orderTime
,t4.guid as categoryGuid
,t4.img as categoryImg
,t4.name as categoryName
,t4.alias as categoryAlias
,ifnull(left(t1.refund_pay_time+0,8),left(t1.refund_pay_time+0,8)) as refundPayTime
,t1.supply_done_flag as refundPayFlag
,ifnull(t1.refund_pay_read_flag,t1.refund_pay_read_flag) as refundPayReadFlag
,t3.id
from 
coz_order_judge t
left join 
coz_order_cancel t1
on t.biz_guid=t1.guid
left join 
coz_order t3 
on t.order_guid=t3.guid 
left join 
coz_category_info t4
on t3.category_guid=t4.guid 
where 
t3.demand_user_id=''{curUserId}'' and t.result<>''3'' and t3.parent_guid='''' and t3.sd_path_guid=''{sdPathGuid}'' and (t.biz_type=''1'') and t1.supply_done_flag=''1''
)t
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;
