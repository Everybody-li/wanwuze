-- ##Title ﻿﻿app-按年度查询服务成果统计
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe ﻿﻿app-按年度查询服务成果统计
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
year as year
,count(1) as orderAcceptNum
from 
coz_serve_order_kpi t1
where t1.demand_gauser_id='{curUserId}' and t1.del_flag='0'
group by year
order by year desc