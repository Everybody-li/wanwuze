-- ##Title web-按类别统计所有产生的采购服务费用
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe ﻿﻿web-按类别统计所有产生的采购服务费用
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
'采购对接成果' as typeStr
,cast(ifnull(sum(money),0.00)/100 as decimal(18,2)) as totalMoney
from 
coz_serve_order_kpi t1
where t1.demand_st3_user_id='{curUserId}' and t1.del_flag='0'
union all
select 
'供应对接成果' as typeStr
,cast(ifnull(sum(money),0.00)/100 as decimal(18,2)) as totalMoney
from 
coz_serve_order_kpi t1
where t1.supply_st3_user_id='{curUserId}' and t1.del_flag='0'