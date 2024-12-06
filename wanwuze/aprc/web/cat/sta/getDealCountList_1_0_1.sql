-- ##Title web-查询交易类跟踪列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询交易类跟踪列表
-- ##CallType[QueryData]

-- ##input categoryName string[20] NULL;品类名称（后端支持模糊搜索），非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;用户id，必填

PREPARE q1 FROM '
select 
t.guid as categoryGuid
,t.name as categoryName
,t.cattype_name as cattypeName
,(select count(1) from coz_category_supplier where category_guid=t.guid and del_flag=''0'') as supplierCount
,(select count(1) from coz_demand_request where category_guid=t.guid and del_flag=''0'') as deReqCount
,(select count(1) from coz_demand_request a inner join coz_demand_request_supply b on b.request_guid=a.guid where a.category_guid=t.guid and a.del_flag=''0'' and b.del_flag=''0'' and b.price_status=''3'') as suPriceCount
,(select count(1) from coz_demand_request a inner join coz_order b on b.request_guid=a.guid where a.category_guid=t.guid and a.del_flag=''0'' and b.del_flag=''0'' and b.pay_status=''2'')  as orderCount
from  
coz_category_info t
where 
(t.name like ''%{categoryName}%'' or ''{categoryName}''='''') and t.del_flag=''0'' and t.mode=2
order by t.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;
