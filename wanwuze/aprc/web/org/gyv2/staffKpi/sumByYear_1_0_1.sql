-- ##Title ﻿﻿app-按月份查询服务成果统计
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-按月份查询服务成果统计
-- ##CallType[QueryData]

-- ##input serveFeeFlag string[1] NOTNULL;服务收费标志(0-免费，1-收费)，必填
-- ##input gyv2UserId string[36] NOTNULL;供应专员用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input year char[4] NOTNULL;年度，必填


select 
year
,month
,cast(ifnull(sum(money),0.00)/100 as decimal(18,2)) as money
from 
coz_order_gyv2_kpi t1
where t1.gyv2staff_user_id='{gyv2UserId}' and t1.serve_fee_flag='{serveFeeFlag}'
group by year,month
order by year desc,month desc