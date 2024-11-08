-- ##Title web-查询非系统名义已裁决列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询非系统名义已裁决列表
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
		t.order_guid AS orderGuid,
		LEFT ( t.create_time, 10 ) AS applyDate,
		''1'' applyType,
		t2.NAME categoryName,
		t1.order_no AS orderNo,
		CASE WHEN ( t.cancel_object = 1 ) THEN t1.demand_user_id ELSE t1.supply_user_id END AS applyUserId,
		t1.demand_user_id AS demandUserId,
		t1.supply_user_id AS supplyUserId,
		LEFT ( t3.create_time, 10 ) AS judgeDate
		,t2.cattype_name as cattypeName
		,(select guid from coz_order_judge where biz_guid=t.guid limit 1) as judgeGuid
		,t4.request_guid as requestGuid
		,t4.guid as requestPriceGuid
		,t4.request_supply_guid as requestSupplyGuid
		,''1'' as demandUserType
		,''2'' as supplyUserType,
		case when (t.cancel_object=''2'') then ''2'' else ''1'' end as applyUserType
		FROM
		coz_order_cancel t
		LEFT JOIN coz_order t1 ON t.order_guid = t1.guid
		LEFT JOIN coz_category_info t2 ON t1.category_guid = t2.guid 
		LEFT JOIN coz_order_judge t3 ON t3.biz_guid = t.guid
		left join
		coz_demand_request_price t4
		on t1.request_price_guid=t4.guid
		WHERE
		t.cancel_object <> ''3'' AND t3.result <> ''0''
		AND ( t1.order_no LIKE ''%{orderNo}%'' OR ''{orderNo}'' = '''' ) 
		UNION ALL
		SELECT
		t.order_guid AS orderGuid,
		LEFT ( t.create_time, 10 ) AS applyDate,
		''2'' AS applyType,
		t2.NAME categoryName,
		t1.order_no AS orderNo,
		t1.demand_user_id AS applyUserId,
		t1.demand_user_id AS demandUserId,
		t1.supply_user_id AS supplyUserId,
		LEFT ( t3.create_time, 10 ) AS judgeDate
		,t2.cattype_name as cattypeName
		,(select guid from coz_order_judge where biz_guid=t.guid limit 1) as judgeGuid
		,t4.request_guid as requestGuid
		,t4.guid as requestPriceGuid
		,t4.request_supply_guid as requestSupplyGuid
		,''1'' as demandUserType
		,''2'' as supplyUserType
		,''1'' as applyUserType
		FROM
		coz_order_refund t
		LEFT JOIN coz_order t1 ON t.order_guid = t1.guid
		LEFT JOIN coz_category_info t2 ON t1.category_guid = t2.guid 
		LEFT JOIN coz_order_judge t3 ON t3.biz_guid = t.guid
		left join
		coz_demand_request_price t4
		on t1.request_price_guid=t4.guid
		WHERE
		( t1.order_no LIKE ''%{orderNo}%'' OR ''{orderNo}'' = '''' )
		AND t3.result <> ''0''
	)t
	order by applyDate desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;