-- ##Title app-供应-关闭需求范围
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-关闭需求范围
-- ##CallType[ExSql]

-- ##input supplierGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_supplier t
set t.range_flag='0'
,t.user_price_mode=case when((select price_mode from coz_category_deal_rule_log where category_guid=t.category_guid and del_flag='0' order by id desc limit 1)='1') then '2' else t.user_price_mode end
,t.update_by='{curUserId}'
,t.update_time=now()
where 
guid='{supplierGuid}'
;
select
user_price_mode as userPriceMode
from
coz_category_supplier
where 
guid='{supplierGuid}'