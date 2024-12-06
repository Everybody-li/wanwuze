-- ##Title web-查看裁决结果信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看裁决结果信息
-- ##CallType[QueryData]

-- ##input judgeGuid char[36] NOTNULL;裁决费用guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t1.guid as judgeGuid
,t1.order_guid as orderGuid
,t3.img as categoryImg
,t3.name as categoryName
,t3.alias as categoryAlias
,t2.order_no as orderNo
,left(t2.create_time,10) as orderTime
,t1.result as judgeResult
,left(t1.create_time,10) as judgeTime
,t1.reason as judgeReason
,t1.third_reports as thirdReports
,cast(t1.disobey_fee/100 as decimal(18,2)) as disobeyFee
,t1.disobey_fee_remark as disobeyRemark
,cast(t1.obey_fee/100 as decimal(18,2)) as obeyFee
,t1.obey_fee_remark as obeyRemark
from
coz_order_judge t1
left join
coz_order t2
on t1.order_guid=t2.guid
left join
coz_category_info t3
on t2.category_guid=t3.guid
where 
t1.guid='{judgeGuid}' and t1.del_flag=0