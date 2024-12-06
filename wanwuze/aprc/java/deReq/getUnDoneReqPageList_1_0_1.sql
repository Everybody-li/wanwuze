-- ##Title 需求-查询一个需求
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 需求-查询一个需求
-- ##CallType[QueryData]

-- ##input supplierGuid char[36] NOTNULL;供方品类guid，必填
-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
t.guid as requestGuid
,category_guid as categoryGuid
,category_name as categoryName
,price_mode as priceMode
,t.user_id as userId
,CONCAT(''{ChildRows_aprc\\\\java\\\\deReq\\\\getUnDoneReqPlatesList_1_0_1:requestGuid='''''',t.guid,''''''}'') as `plates`
from
coz_demand_request t
left join coz_demand_request_supply t2 on t.guid = t2.request_guid and t2.supplier_guid = ''{supplierGuid}''
where 
t.category_guid=''{categoryGuid}'' and t.done_flag=''0'' and t.del_flag=''0'' and t.cancel_flag=''0''and t2.guid is null
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;