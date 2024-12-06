-- ##Title web-查询需求验收通过管理的订单详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询需求验收通过管理的订单详情
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input supplyUserId char[36] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input orderNo string[30] NULL;采购编号(模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select
t2.guid as orderGuid
,t2.demand_user_id as demandUserId
,t2.supply_user_id as supplyUserId
,t1.cattype_guid as cattypeGuid
,t1.cattype_name as cattypeName
,t1.category_guid as categoryGuid
,t1.category_name as categoryName
,t1.guid as demandRequestGuid
,left(t1.create_time,16) as demandRequestCreateTime
,left(t2.create_time,16) as createTime
,t2.order_no as orderNo
from 
coz_demand_request t1
inner join
coz_order t2
on t1.guid=t2.request_guid
where 
(t2.accept_status=''1'') and t1.del_flag=''0'' and t2.del_flag=''0'' and (t2.order_no like''%{orderNo}%'' or ''{orderNo}''='''') and t1.category_guid=''{categoryGuid}'' and t2.supply_user_id=''{supplyUserId}''
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;