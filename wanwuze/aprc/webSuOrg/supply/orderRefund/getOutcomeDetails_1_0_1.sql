-- ##Title web-查询订单成果详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询订单成果详情
-- ##CallType[QueryData]

-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output createTime string[10] 成果上传日期;成果上传日期（式：0000-00-00）
-- ##output type int[>=0] 1;成果类型（1：图片，2：文档）

select
*
,CONCAT('{ChildRows_aprc\\webSuOrg\\supply\\orderRefund\\getOutcomeDetailData_1_0_1:orderGuid=''',t.orderGuid,''' and createTime=''',t.createTime,''' and type=''',t.type,''' and createTime=''',t.createTime,'''}') as data
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
