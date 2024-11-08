-- ##Title app-采购/供应-查看裁决结果信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购/供应-查看裁决结果信息
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output judgeGuid char[36] 裁决guid;裁决guid
-- ##output bizType int[>=0] 1;业务类型：1-订单取消，2-订单退货
-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output categoryImg string[50] 品类图片;品类图片
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output categoryalias string[50] 品类别名;品类别名，多个逗号隔开
-- ##output orderNo string[50] 采购编号;采购编号
-- ##output orderTime string[10] 0000-00-00;订单日期（格式：0000-00-00）
-- ##output judgeResult int[>=0] 1;裁决结果：1：需方违约，支持退款，2：供方违约，支持退款，3：交易正常，维持交易，4：交易取消，支持退款）
-- ##output judgeTime string[10] 0000-00-00;裁决日期（格式：0000-00-00）
-- ##output judgeReason string[50] 裁决理由;裁决理由
-- ##output thirdReports string[600] 第三方报告图片;第三方报告图片，多个逗号隔开
-- ##output disobeyFee int[50] 50.00;违约费用（保留2位小数）
-- ##output disobeyRemark string[50] 违约费用说明;违约费用说明
-- ##output obeyFee int[50] 50.00;赔偿金额（保留2位小数）
-- ##output obeyRemark string[50] 赔偿金额说明;赔偿金额说明

select 
t.guid as judgeGuid
,t.biz_type as bizType
,t.order_guid as orderGuid
,t4.img as categoryImg
,t4.name as categoryName
,t4.alias as categoryAlias
,t3.order_no as orderNo
,left(t3.create_time,10) as orderTime
,t.result as judgeResult
,left(t.update_time,10) as judgeTime
,t.reason as judgeReason
,t.third_reports as thirdReports
,cast(t.disobey_fee/100 as decimal(18,2)) as disobeyFee
,t.disobey_fee_remark as disobeyRemark
,cast(t.obey_fee/100 as decimal(18,2)) as obeyFee
,t.obey_fee_remark as obeyRemark
from 
coz_order_judge t
left join 
coz_order t3 
on t.order_guid=t3.guid 
left join 
coz_category_info t4
on t3.category_guid=t4.guid 
where 
t.order_guid='{orderGuid}'

