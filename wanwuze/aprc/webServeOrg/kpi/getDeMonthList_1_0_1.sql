-- ##Title web-查询采购对接业绩年度详情(月份列表）
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询采购对接业绩年度详情(月份列表）
-- ##CallType[QueryData]

-- ##input year string[4] NOTNULL;登录用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t.year
,t.month
,cast(sum(t.money)/100 as decimal(18,2)) as money
from 
coz_serve_order_kpi t
where demand_seorg_guid='{curUserId}' and t.year='{year}' and t.del_flag='0'
group by t.year,t.month
order by t.month desc