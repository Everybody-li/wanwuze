-- ##Title ﻿﻿web-根据年度按月份查询服务业绩统计
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe ﻿﻿web-根据年度按月份查询服务业绩统计
-- ##CallType[QueryData]

-- ##input year string[4] NOTNULL;登录用户id，必填
-- ##input month string[2] NOTNULL;登录用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
*
from
(
select 
t.year
,t.month
,right(left(t.create_time,10),2) as day
,cast(sum(t.money)/100 as decimal(18,2)) as money
from 
coz_serve_order_kpi t
where t.year='{year}' and t.month='{month}' and t.del_flag='0'
group by t.year,t.month,right(left(t.create_time,10),2)
)t
order by t.day desc