-- ##Title app-采购-查询订单状态管理列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-查询订单状态管理列表
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NULL;订单guid
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output categoryGuid char[36] 品类guid;品类guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output categoryImg string[50] 品类图片;品类图片
-- ##output categoryalias string[50] 品类别名;品类别名，多个逗号隔开
-- ##output orderNo string[24] 采购编号;采购编号
-- ##output orderTime string[10] 订单创建日期;订单创建日期（格式：0000-00-00）
-- ##output orderStatus string[10] 最新订单状态;最新订单状态（1：需方取消订单--需方操作，2：供方取消订单--供方操作，3：订单交易仲裁--系统操作，4：供方处理完成--供方操作，5：需方验收通过--需方操作，6：需方退货申请--需方操作，7：需方退货完成--需方操作，8：供方验收不通过--供方操作，9：供方验收通过---供方操作）

select 
t.guid as orderGuid
,t.category_guid as categoryGuid
,t1.name as categoryName
,t1.img as categoryImg
,t1.alias as categoryAlias
,t.order_no as orderNo
,left(t.create_time,10) as orderTime
,(select status from coz_order_operation_log where order_guid=t.guid order by create_time desc limit 1) as orderStatus
from  
coz_order t
inner join 
coz_category_info t1
on t.category_guid=t1.guid 
where 
t.demand_user_id='{curUserId}' and t.del_flag='0' and t.pay_status='2' and t.parent_guid='' and t.sd_path_guid='{sdPathGuid}'
order by t.create_time desc
Limit {compute:[({page}-1)*{size}]/compute},{size};