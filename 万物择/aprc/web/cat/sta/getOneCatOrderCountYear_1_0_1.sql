-- ##Title web-按年查询订单数量-交易类
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-按年查询订单数量-交易类
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;用户id，必填

-- ##output orderYear string[4] 年份;年份
-- ##output orderCount int[>=0] 1;订单数量

PREPARE q1 FROM '
select
*
from
(
select 
left(t.create_time,4) as orderYear
,count(1) as orderCount
from  
coz_order t
left join
coz_category_info t1
on t.category_guid=t1.guid
where 
t.category_guid=''{categoryGuid}'' and t.del_flag=''0'' and t1.mode=2 and t.pay_status=''2''
group by left(t.create_time,4)
)t
order by orderYear desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;