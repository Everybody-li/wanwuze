-- ##Title web-查询服务调度专员处的询价专员成果管理(月份汇总)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务调度专员处的询价专员成果管理(月份汇总)
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
month
from
(
select 
left(t1.request_time,7) as month
from 
coz_demand_request_serve2_source t1
inner join
sys_user t3
on t1.aprice_staff_user_id=t3.user_id
where 
t3.del_flag=''0'' and t3.status=''0'' 
group by left(t1.request_time,7)
union all
select 
left(t2.price_time,7) as month
from 
coz_demand_request_supply_serve2_source t2
inner join
sys_user t3
on t2.aprice_staff_user_id=t3.user_id
where 
t3.del_flag=''0'' and t3.status=''0'' 
group by left(t2.price_time,7)
union all
select 
left(t3.accept_time,7) as month
from 
coz_order t3
inner join
coz_order_serve2_source t4
on t3.guid=t4.order_guid
inner join
sys_user t5
on t4.aprice_staff_user_id=t5.user_id
where 
t3.del_flag=''0'' and t5.del_flag=''0'' and t5.status=''0'' and t3.accept_status=''1'' 
group by left(t3.accept_time,7)
)t
group by month
order by month desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;