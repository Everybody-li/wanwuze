-- ##Title  web-按年度月份统计招募专员角色的采购服务费用
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe  web-按年度月份统计招募专员角色的采购服务费用
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select 
t1.year
,t1.month
,cast(sum(t1.money)/100 as decimal(18,2)) as money
from 
coz_serve_order_kpi t1
where (length(t1.demand_seorg_guid)>1 or length(t1.supply_seorg_guid)>1) and t1.del_flag=''0''
group by t1.year,t1.month
order by t1.year desc,t1.month desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;