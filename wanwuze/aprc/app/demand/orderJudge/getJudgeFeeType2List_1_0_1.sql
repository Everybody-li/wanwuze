-- ##Title app-采购/供应-订单违约费用缴纳列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购/供应-订单违约费用缴纳列表
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output categoryGuid char[36] 品类guid;品类guid
-- ##output categoryImg string[50] 品类图片;品类图片
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output categoryAlias string[50] 品类别名;品类别名，多个逗号隔开
-- ##output orderNo string[24] 采购编号;采购编号
-- ##output orderTime string[10] 0000-00-00;订单创建时间（格式：0000-00-00）
-- ##output judgeFeePayType string[1] 1;违约费用缴纳标志（0：未缴纳，其他值：已缴纳）
-- ##output appReadFlag string[1] 1;阅读标志（1：未读，2：已读）
-- ##output judgeFeeGuid char[36] 违约费用guid;违约费用guid

PREPARE q1 FROM '
select 
t.order_guid as orderGuid
,t4.guid as categoryGuid
,t4.img as categoryImg
,t4.name as categoryName
,t4.alias as categoryAlias
,t3.order_no as orderNo
,left(t3.create_time,10) as orderTime
,t1.pay_status as judgeFeePayStatus
,t1.app_read_flag as appReadFlag
,t1.guid as judgeFeeGuid
from 
coz_order_judge_fee t1
left join 
coz_order_judge t
on t1.judge_guid=t.guid 
left join 
coz_order t3 
on t.order_guid=t3.guid 
left join 
coz_category_info t4
on t3.category_guid=t4.guid 
where 
t.obey_user_id=''{curUserId}'' and (t3.sd_path_guid=''{sdPathGuid}'') and t1.fee_type=''2'' and t.disobey_object=''2'' and t3.parent_guid=''''
order by t.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;