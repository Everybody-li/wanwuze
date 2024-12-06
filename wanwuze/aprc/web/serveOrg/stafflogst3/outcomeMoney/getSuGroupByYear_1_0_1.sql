-- ##Title ﻿﻿﻿﻿app-按年度查询服务业绩统计
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe ﻿﻿app-按年度查询服务业绩统计
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
year as year
,cast(ifnull(sum(money),0.00)/100 as decimal(18,2)) as money
from 
coz_serve_order_kpi t1
where t1.supply_st3_user_id='{curUserId}' and t1.del_flag='0'
group by year
order by year desc