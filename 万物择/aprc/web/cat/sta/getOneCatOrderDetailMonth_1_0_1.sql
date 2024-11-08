-- ##Title web-查询订单月份详情-交易类
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询订单月份详情-交易类
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input orderMonth string[7] NOTNULL;订单月份（前端拼凑格式：0000-00），必填
-- ##input orderNo string[20] NULL;供方手机号（后端支持模糊搜索），非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;用户id，必填

-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output orderNo string[24] 采购编号;采购编号
-- ##output orderDate string[10] 订单日期;订单日期（格式：0000-00-00）
-- ##output demandUserId char[36] 采购方用户id;采购方用户id
-- ##output supplyUserId char[36] 供应方用户id;供应方用户id

PREPARE q1 FROM '
select
*
from
(
select 
t.guid as orderGuid
,t.order_no as orderNo
,left(t.create_time,10) as orderDate
,t.demand_user_id as demandUserId
,t.supply_user_id as supplyUserId
from  
coz_order t
left join
coz_category_info t1
on t.category_guid=t1.guid
where 
t.category_guid=''{categoryGuid}'' and t.del_flag=0 and t1.mode=2 and left(t.create_time,7)=''{orderMonth}'' and (t.order_no like ''%{orderNo}%'' or ''{orderNo}''='''')
)t
order by orderDate desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;