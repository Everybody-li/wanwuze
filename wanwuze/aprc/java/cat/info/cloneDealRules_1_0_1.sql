-- ##Title 接口3：复制品类类型的交易规则信息给下属的未发布过交易规则的品类名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 接口3：复制品类类型的交易规则信息给下属的未发布过交易规则的品类名称
-- ##CallType[ExSql]

-- ##input guid char[36] NOTNULL;交易规则guid
-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input priceMode char[1] NOTNULL;报价类型
-- ##input publishTime char[19] NOTNULL;发布时间
-- ##input serveFeeFlag char[1] NOTNULL;收取服务费（0-免费，1-收费）
-- ##input curUserId string[36] NOTNULL;登录用户id，必填



insert into coz_category_deal_rule_log (guid,deal_rule_guid,category_guid,price_mode,serve_fee_flag,publish_time,create_by,create_time,update_by,update_time)
select
UUID()
,'{guid}'
,'{categoryGuid}'
,'{priceMode}'
,'{serveFeeFlag}'
,now()
,'{curUserId}'
,now()
,'{curUserId}'
,now();


