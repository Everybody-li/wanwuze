-- ##Title app-采购-查询已提的需求列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-查询已提的需求列表
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;需方用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select
t.sd_path_guid as sdPathGuid
,t.sd_path_all_name as sdPathAllName
,t.guid as requestGuid
,t.status0_read_flag
,t.category_guid as categoryGuid
,t.category_name as categoryName
,t.category_img as categoryImg
,t.category_alias as categoryAlias
,t.status0_read_flag as status0ReadFlag
,(select count(1) from coz_demand_request_supply where price_status=''3'' and request_guid=t.guid) as totalSupplyNum
,(select count(1) from coz_demand_request_supply where de_read_flag=''1'' and price_status=''3'' and request_guid=t.guid) as unReadPriceNum
,left(t.create_time,19) as reqCreateTime
,(select guid from coz_demand_request_price where request_guid=t.guid and del_flag=''0'' limit 1) as requestPriceGuid
,case when exists(select 1 from coz_demand_request_supply where request_guid=t.guid and del_flag=''0'' and price_status=''2'') then ''1'' else ''0'' end as QueryRefuPriceBtnFlag
from
coz_demand_request t
where 
t.sd_path_guid=''{sdPathGuid}'' and t.del_flag=''0'' and t.done_flag=''0'' and (t.status0_read_flag=''0'' or t.status0_read_flag=''1'') and t.user_id=''{curUserId}'' and t.cancel_flag=''0'' and (parent_guid='''' or parent_guid is null)  and t.category_mode=2
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;