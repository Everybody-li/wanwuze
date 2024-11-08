-- ##Title 更新采购需求的供方报价选中状态
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 更新采购需求的供方报价选中状态
-- ##CallType[ExSql]

-- ##input requestPriceGuid string[200] NOTNULL;需求供方报价guid，必填

set @reqSupplyGuid = cast('0' as char character set utf8);
select request_supply_guid into @reqSupplyGuid from coz_demand_request_price where guid='336af192-8eb2-4dc5-9f4e-0b4785b3ffc2' and del_flag='0';

update coz_demand_request_supply
set select_flag='1'
,update_time=now()
where guid=@reqSupplyGuid;

update coz_demand_request_price
set selected_flag='1'
,update_time=now()
where guid='{requestPriceGuid}'