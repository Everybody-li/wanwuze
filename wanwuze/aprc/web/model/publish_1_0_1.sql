-- ##Title web-发布节点交易规则
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-发布节点交易规则
-- ##CallType[QueryData]

-- ##input dealRuleGuid char[36] NOTNULL;节点交易模式guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output publishNum int[>=0] 10;发布次数（0：未发布过，这是第一次发布，>0：非第一次发布）

select count(1) from 
coz_category_deal_rule_log t
where 
guid='{dealRuleGuid}'
;
set @categoryGuid='',@cattypeGuid='',@priceMode='',@serveFeeFlag='';
select category_guid,cattype_guid,price_mode,serve_fee_flag into @categoryGuid,@cattypeGuid,@priceMode,@serveFeeFlag
from coz_category_deal_rule where del_flag='0' and guid='{dealRuleGuid}'
;
update coz_category_deal_rule t
set publish_flag=2
,publish_time=now()
,price_mode=@priceMode
,serve_fee_flag=@serveFeeFlag
where guid='{dealRuleGuid}'
;
insert into coz_category_deal_rule_log (guid,deal_rule_guid,category_guid,price_mode,serve_fee_flag,publish_time,create_by,create_time,update_by,update_time)
select
UUID()
,'{dealRuleGuid}'
,category_guid
,price_mode
,serve_fee_flag
,now()
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_category_deal_rule t
where guid='{dealRuleGuid}'
;
update coz_category_service_fee
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where category_guid=@categoryGuid and @categoryGuid<>@cattypeGuid and @serveFeeFlag='1'
;