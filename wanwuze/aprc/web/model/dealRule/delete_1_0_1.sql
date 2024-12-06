-- ##Title web-移除一行品类规则
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-移除一行品类规则
-- ##CallType[ExSql]

-- ##input dealRuleGuid char[36] NOTNULL;节点交易规则guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_category_deal_rule t
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where t.category_guid<>t.cattype_guid and not exists(select 1 from coz_category_info where guid=t.category_guid and del_flag='0') and t.guid='{dealRuleGuid}'

