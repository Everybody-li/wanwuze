-- ##Title app-采购/供应-查询供方处理订单情况(交付情况)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购/供应-查询供方处理订单情况(交付情况)
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NULL;订单guid
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output supplyDoneTime string[10] 0000年-00月-00日;供方处理订单时间/交付日期（格式：0000年-00月-00日）
-- ##output supplyDoneFlag int[>=0] 1;供方处理订单结果（0：未处理，1：已处理）
-- ##output bizRuleType3Guid char[36] 适用规则-订单确认完成规则guid;适用规则-订单确认完成规则guid
-- ##output bizRuleType3Name string[100] 订单确认完成规则名称;订单确认完成规则名称

select 
concat(left(t.supply_done_time,4),'年',right(left(t.supply_done_time,7),2),'月',right(left(t.supply_done_time,10),2),'日') as supplyDoneTime
,t.supply_done_flag as supplyDoneFlag
,t.biz_rule_type3 as bizRuleType3Guid
,t1.name as bizRuleType3Name
from 
coz_order t
left join
coz_order_bussiness_rule t1
on t.biz_rule_type3=t1.guid
where 
t.guid='{orderGuid}'