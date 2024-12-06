-- ##Title ﻿﻿﻿﻿web-查询供应机构供应机构成果列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供应机构供应机构成果列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input categoryName string[50] NULL;供应机构名称(模糊搜索)，非必填
-- ##input orgStalogST2Guid char[36] NOTNULL;结算机构guid，必填



select 
count(1) as orderNum
from 
coz_order_gyv2_kpi t
where t.gyv2re_stalog_guid='{orgStalogST2Guid}'
