-- ##Title ﻿﻿web-按年度查询服务业绩统计
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe ﻿﻿web-按年度查询服务业绩统计
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填



select 
t.year
,cast(sum(t.money)/100 as decimal(18,2)) as money
from 
coz_serve_order_kpi t
where t.del_flag='0'
group by t.year
order by t.year desc