-- ##Title web-设置交接节点
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-设置交接节点
-- ##CallType[ExSql]

-- ##input dealRuleGuid char[36] NOTNULL;节点规则guid，必填
-- ##input priceMode int[>=0] NOTNULL;供应报价节点页面格式(1：型号(模式)报价，2：按单(模式)报价），必填
-- ##input serveFeeFlag int[>=0] NOTNULL;收取服务费（0：免费，1：收费），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_deal_rule t
set publish_flag='0'
,price_mode='{priceMode}'
,serve_fee_flag='{serveFeeFlag}'
,update_by='{curUserId}'
,update_time=now()
where guid='{dealRuleGuid}' and (category_guid=cattype_guid or exists(select 1 from coz_category_info where guid=t.category_guid and del_flag='0'))
;
