-- ##Title app-供应-查询订单验收通过结算列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-查询订单验收通过结算列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input cattypeGuid char[36] NULL;品类类型guid，必填


-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output orderFeeSettleGuid char[36] 订单费用结算guid;订单guid
-- ##output orderTime string[10] 订单日期;订单日期(格式：0000-00-00)
-- ##output categoryGuid char[36] 品类guid;品类guid
-- ##output categoryImg string[50] 品类图片;品类图片
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output categoryalias string[50] 品类别名;品类别名，多个逗号隔开
-- ##output settleTime string[24] 到款时间;到款时间(格式：0000-00-00)
-- ##output payType int[>=0] 1;到款标志（0：未到款，其他值：已到款）
-- ##output readFlag int[>=0] 1;到款阅读标志（1：未读，1：已读）


select 
t.guid as orderGuid
,t.order_no as orderNo
,t2.guid as orderFeeSettleGuid
,left(t.create_time,10) as orderTime
,t1.guid as categoryGuid
,t1.img as categoryImg
,t1.name as categoryName
,t1.alias as categoryAlias
,ifnull(t2.pay_type,'0') as payType
,left(t.pay_time,10) as settleTime
,t2.read_flag as readFlag
from  
coz_order t
left join 
coz_category_info t1
on t.category_guid=t1.guid 
left join 
coz_order_fee_settle t2
on t.guid=t2.order_guid
where 
t.supply_user_id='{curUserId}' and t.del_flag='0' and t.accept_status='1' and t1.cattype_guid='{cattypeGuid}'
order by t.id desc

