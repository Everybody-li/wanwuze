-- ##Title web-更新指派规则设置
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-更新指派规则设置
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;字段名称guid，必填
-- ##input ruleType int[>=0] NOTNULL;指派规则类型（1：同一单子，价格低者中单；同价格，已中单少者中单；已中单数量相同，早合作者中单；以上均满足，则随机。），必填
-- ##input curUserId string[36] MOTNULL;登录用户id，必填

update coz_category_model_supply_assign
set publish_flag='0',rule_type='{ruleType}'
where category_guid='{categoryGuid}'
;
