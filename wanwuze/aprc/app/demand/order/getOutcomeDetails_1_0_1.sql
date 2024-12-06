-- ##Title web-查询订单成果详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询订单成果详情
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
*
,CONCAT('{ChildRows_aprc\\app\\demand\\order\\getOutcomeDetailData_1_0_1:orderGuid=''',t.orderGuid,''' and createTime=''',t.createTime,''' and type=''',t.type,'''}') as data
from
(
	select
	orderGuid
	,createTime
	,type
	from
	(
		select 
		order_guid as orderGuid
		,left(create_time,10) as createTime
		,type
		from 
		coz_order_outcome 
		where 
		order_guid='{orderGuid}' and del_flag='0'
	)t
	group by createTime,type
)t
