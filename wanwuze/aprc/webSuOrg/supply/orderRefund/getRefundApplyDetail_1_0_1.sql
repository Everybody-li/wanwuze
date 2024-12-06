-- ##Title app-采购/供应-查询退货申请
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购/供应-查询退货申请
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output refundTime string[10] 0000-00-00;订单退货申请时间（格式：0000年-00月-00日）
-- ##output reason string[200] 退货理由;供退货理由
-- ##output proveImgs string[20] 退货证明图片;退货证明图片，多个逗号隔开
-- ##output bizRuleType21Guid char[36] 退货裁决规则guid;退货裁决规则guid
-- ##output bizRuleType21Name string[20] 退货裁决规则名称;退货裁决规则名称

select
concat(left(t.create_time,4),'年',right(left(t.create_time,7),2),'月',right(left(t.create_time,10),2),'日') as refundTime
,t.reason
,t.prove_imgs as proveImgs
,t.biz_rule_type21 as bizRuleType21Guid
,t1.name as bizRuleType21Name
from
coz_order_refund t
left join 
coz_order_bussiness_rule t1
on t.biz_rule_type21=t1.guid
where 
t.order_guid='{orderGuid}' and t.del_flag='0'