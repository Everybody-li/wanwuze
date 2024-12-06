-- ##Title ﻿﻿web-根据年度按月份查询服务业绩统计
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe ﻿﻿web-根据年度按月份查询服务业绩统计
-- ##CallType[QueryData]

-- ##input acceptDay string[10] NOTNULL;登录用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
t.guid as cattypeGuid
,t.name as cattypeName
,(select cast(ifnull(sum(money),0.00)/100 as decimal(18,2)) from coz_serve_order_kpi where cattype_guid=t.guid and del_flag='0' and left(create_time,10)='{acceptDay}') as money
,'{acceptDay}' as acceptDay
from 
coz_cattype_fixed_data t
where t.del_flag='0' and t.mode='2'
order by t.norder desc