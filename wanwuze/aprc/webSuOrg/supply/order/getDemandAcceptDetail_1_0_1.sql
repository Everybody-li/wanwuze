-- ##Title app-采购/供应-查询验收情况
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购/供应-查询验收情况
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;采购供应路径关联guid，必填
-- ##input curUserId string[36] NOTNULL;供方用户id，必填

-- ##output demandAcceptTime string[10] 需方验收时间;需方验收时间（格式：0000年-00月-00日）
-- ##output demandAcceptWay int[>=0] 1;需方验收方式（1：手工验收，2：系统验收）
-- ##output demandAcceptStatus int[>=0] 1;需方验收状态(1：验收通过，2：验收不通过)
-- ##output orderRefundGuid char[36] 订单退货guid（查看事由需要用到）;订单退货guid（查看事由需要用到）
-- ##output bizRuleType2Guid char[36] 适用规则-品类验收规则guid;适用规则-品类验收规则guid
-- ##output bizRuleType2Name string[100] 品类验收规则名称;品类验收规则名称


select 
concat(left(t.accept_time,4),'年',right(left(t.accept_time,7),2),'月',right(left(t.accept_time,10),2),'日') as demandAcceptTime
,t.accept_way as demandAcceptWay
,t.accept_status as demandAcceptStatus
,'c9b5995b-7374-11ec-a478-0242ac120003' as bizRuleType2Guid
,(select name from coz_order_bussiness_rule where guid='c9b5995b-7374-11ec-a478-0242ac120003') as bizRuleType2Name

from 
coz_order t
where 
t.guid='{orderGuid}'