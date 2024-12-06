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
set @categoryGuid='',@cattypeGuid='',@priceMode='',@serveFeeFlag='',@cloneFalg='';
select category_guid,cattype_guid,price_mode,serve_fee_flag,case when(category_guid=cattype_guid) then clone_falg else '0' end into @categoryGuid,@cattypeGuid,@priceMode,@serveFeeFlag,@cloneFalg
from coz_category_deal_rule where del_flag='0' and guid='{dealRuleGuid}'
;
set @flag1=(select case when ( (select price_mode from coz_category_deal_rule_log where deal_rule_guid='{dealRuleGuid}' and del_flag='0' order by id desc limit 1)=CAST(@priceMode AS char CHARACTER SET utf8)) then '0' else '1' end)
;
update coz_category_supplier
set price_mode=@priceMode
,price_mode_chflag='1'
,read_pm_chflag='1'
,price_mode_chtime=now()
,range_flag='0'
,user_price_mode=@priceMode
,update_time = now()
,update_by = '{curUserId}'
where category_guid=CAST(@categoryGuid AS char CHARACTER SET utf8) and @flag1='1'
;
update coz_category_deal_rule t
set publish_flag=2
,publish_time=now()
,price_mode=@priceMode
,serve_fee_flag=@serveFeeFlag
,update_time = now()
,update_by = '{curUserId}'
where guid='{dealRuleGuid}' or
(
not exists(select 1 from coz_category_deal_rule_log where category_guid=t.category_guid) and
cattype_guid=CAST(@categoryGuid AS char CHARACTER SET utf8) and CAST(@cloneFalg AS char CHARACTER SET utf8)='1'
)
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
where guid='{dealRuleGuid}' or 
(
not exists(select 1 from coz_category_deal_rule_log where category_guid=t.category_guid) and
cattype_guid=CAST(@categoryGuid AS char CHARACTER SET utf8) and CAST(@cloneFalg AS char CHARACTER SET utf8)='1'
)
;
update coz_category_service_fee
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where category_guid=CAST(@categoryGuid AS char CHARACTER SET utf8) and @categoryGuid<>@cattypeGuid and @serveFeeFlag='1'
;