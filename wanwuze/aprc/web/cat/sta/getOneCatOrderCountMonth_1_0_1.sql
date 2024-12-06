-- ##Title web-按月份查询订单数量-交易类
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-按月份查询订单数量-交易类
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input year string[4] NOTNULL;年份
-- ##input curUserId string[36] NOTNULL;用户id，必填

-- ##output orderMonth string[7] 月份;月份
-- ##output orderCount int[>=0] 1;订单数量


select
*
from
(
select 
left(t.create_time,7) as orderMonth
,count(1) as orderCount
from  
coz_order t
left join
coz_category_info t1
on t.category_guid=t1.guid
where 
t.category_guid='{categoryGuid}' and t.del_flag='0' and t1.mode=2 and left(t.create_time,4)='{year}'
group by left(t.create_time,7)
)t
order by orderMonth desc
