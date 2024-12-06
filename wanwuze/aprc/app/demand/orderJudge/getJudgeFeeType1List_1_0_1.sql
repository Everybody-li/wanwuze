-- ##Title app-采购-订单违约费用缴纳列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购/供应-订单违约费用缴纳列表
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output judgeFee decimal[>=0] 1;违约金额(后端除以100保留2位小数)
-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output judgeTime string[10] 订单违约时间;订单违约时间（格式：0000-00-00）
-- ##output judgeFeePayType string[1] 1;违约费用缴纳标志（0：未缴纳，其他值：已缴纳）
-- ##output judgeGuid char[36] 仲裁guid;仲裁guid
-- ##output judgeFeeGuid char[36] 违约费用guid;违约费用guid
-- ##output judgeFeeNo string[10] 账单编号;账单编号（费用编号）

PREPARE q1 FROM '
select 
cast(t.disobey_fee/100 as decimal(18,2)) as judgeFee
,t.order_guid as orderGuid
,left(t.create_time,10) as judgeTime
,t1.pay_status as judgeFeePayStatus
,t.guid as judgeGuid
,t1.guid as judgeFeeGuid
,t1.fee_no as judgeFeeNo
from 
coz_order_judge t
left join 
coz_order_judge_fee t1
on t1.judge_guid=t.guid 
left join 
coz_order t3 
on t.order_guid=t3.guid 
left join 
coz_category_info t4
on t3.category_guid=t4.guid 
where 
t.disobey_user_id=''{curUserId}'' and (t3.sd_path_guid=''{sdPathGuid}'') and t1.fee_type=''1'' and t.disobey_object=''1'' and t3.parent_guid=''''
order by t.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;