-- ##Title web-查询系统名义已裁决列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询系统名义已裁决列表
-- ##CallType[QueryData]

-- ##input orderNo string[24] NULL;采购编号，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
	select
	*
	from
	(
		SELECT
		t.order_guid as orderGuid,
		left( t.create_time, 10 ) as applyDate,
		1 as applyType,
		t2.name as categoryName,
		t1.order_no as orderNo,
		CASE WHEN ( t.cancel_object = 1 ) THEN t1.demand_user_id ELSE t1.supply_user_id END as applyUserId,
		t1.demand_user_id as demandUserId,
		t1.supply_user_id as supplyUserId,
		left( t3.create_time, 10 ) as judgeDate
		,t2.cattype_name as cattypeName
		,(select guid from coz_order_judge where biz_guid=t.guid limit 1) as judgeGuid
		,t4.request_guid as requestGuid
		,t4.guid as requestPriceGuid
		,t4.request_supply_guid as requestSupplyGuid
		,''1'' as demandUserType
		,''2'' as supplyUserType
		from 
		coz_order_cancel t
		left join 
		coz_order t1 
		on t.order_guid=t1.guid 
		left join 
		coz_category_info t2 
		on t1.category_guid=t2.guid 
		left join
		coz_order_judge t3
		on t3.biz_guid=t.guid
		left join
		coz_demand_request_price t4
		on t1.request_price_guid=t4.guid
		where t3.result<>''0'' and t.cancel_object=''3'' and (t1.order_no like ''%{orderNo}%'' or ''{orderNo}''='''') 
	)t
	order by applyDate desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;