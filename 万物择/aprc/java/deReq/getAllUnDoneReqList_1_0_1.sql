-- ##Title 需求-查询所有未完成交易的需求列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 需求-查询所有未完成交易的需求列表
-- ##CallType[QueryData]

select
'aprcBizParam' as Name
,t.guid as `Key`
,'0' as NewValue
,t.category_guid as categoryGuid
,t.category_name as categoryName
,t.cattype_guid as cattypeGuid
,t.sd_path_guid as sdPathGuid
,t.price_mode as priceMode
,t.serve_fee_flag as serveFeeFlag
,cdp.supply_path_guid as supplyPathGuid
from 
coz_demand_request t
inner join coz_cattype_sd_path cdp on t.sd_path_guid = cdp.guid
where 
t.done_flag='0' and t.del_flag='0' and t.cancel_flag='0' and t.parent_guid = '' and t.category_mode = 2;
