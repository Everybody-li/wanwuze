-- ##Title web-查询订单成果接收
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询订单成果接收
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
t3.name as categoryName
,t3.img as categoryImg
,t3.alias as categoryAlias
,left(t2.create_time,10) as orderDate
,t2.order_no as orderNo
,CONCAT('{ChildRows_aprc\\web\\order\\getOutcomeDetails_1_0_1:orderGuid=''',t2.GUID,'''}') as outcome
from  
coz_order t2
left join 
coz_category_info t3
on t2.category_guid=t3.guid 
where 
t2.guid='{orderGuid}' and t2.del_flag='0'
