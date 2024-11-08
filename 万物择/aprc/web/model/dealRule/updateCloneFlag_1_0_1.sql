-- ##Title web-品类类型通用配置-修改克隆管理开关标志
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-品类类型通用配置-修改克隆管理开关标志
-- ##CallType[ExSql]

-- ##input dealRuleGuid char[36] NOTNULL;节点规则guid，必填
-- ##input cloneFlag int[>=0] NOTNULL;克隆管理是否开启(0-否，1-是)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_deal_rule t
set clone_falg='{cloneFlag}'
,update_by='{curUserId}'
,update_time=now()
where guid='{dealRuleGuid}'
;
