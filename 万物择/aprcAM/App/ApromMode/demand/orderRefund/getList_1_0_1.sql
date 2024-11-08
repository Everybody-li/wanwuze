-- ##Title app-管理-审批模式下的品类-费用结算管理-订单退款接收-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-08-08
-- ##Describe 查询当前采购供应路径下的需方自己的订单的退款数据列表，查询退款已支付的
-- ##Describe 表名：coz_order t1,coz_order_cancel t2
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output orderNo string[24] 采购编号;采购编号
-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output orderCancelGuid char[36] 订单退货guid;订单取消guid
-- ##output orderTime string[10] 订单日期;订单日期（格式：0000-00-00）
-- ##output categoryGuid char[36] 品类guid;品类guid
-- ##output categoryImg string[50] 品类图片;品类图片
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output categoryalias string[50] 品类别名;品类别名，多个逗号隔开
-- ##output refundPayTime string[50] 退款时间;退款时间(格式：00000000)
-- ##output refundPayFlag string[1] 1;退款支付标志(0：未支付，1：已支付)
-- ##output refundPayReadFlag string[1] 1;退款支付阅读标志(1：未读，1-已读)

PREPARE q1 FROM '
select
*
from
(
select 
t3.order_no as orderNo
,t1.order_guid as orderGuid
,t1.guid as orderCancelGuid
,left(t3.create_time,10) as orderTime
,t4.guid as categoryGuid
,t4.img as categoryImg
,t4.name as categoryName
,t4.alias as categoryAlias
,ifnull(left(t1.refund_pay_time+0,8),left(t1.refund_pay_time+0,8)) as refundPayTime
,case when(t1.refund_pay_status=''2'') then ''1'' else ''0'' end as refundPayFlag
,t1.refund_pay_read_flag as refundPayReadFlag
,t3.id
from 
coz_order_cancel t1
left join 
coz_order t3 
on t1.order_guid=t3.guid 
left join 
coz_category_info t4
on t3.category_guid=t4.guid 
where 
t3.demand_user_id=''{curUserId}'' and t3.sd_path_guid=''{sdPathGuid}'' and (t1.refund_pay_status=''2'')
)t
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;
