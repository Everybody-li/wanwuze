-- ##Title ﻿﻿app-按月份查询服务成果统计
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-按月份查询服务成果统计
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input year char[4] NOTNULL;年度，必填


select 
year
,month
,cast(ifnull(sum(money),0.00)/100 as decimal(18,2)) as money
from 
coz_serve_order_kpi t1
where t1.demand_gauser_id='{curUserId}' and t1.year='{year}' and t1.del_flag='0'
group by year,month
order by year desc,month desc