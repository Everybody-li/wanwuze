-- ##Title ﻿﻿﻿﻿web-查询供应机构供应机构成果列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供应机构供应机构成果列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input categoryName string[50] NULL;供应机构名称(模糊搜索)，非必填
-- ##input orgStalogST2Guid char[36] NOTNULL;结算机构guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select 
count(1) as orderNum
,t.category_name as categoryName
,t.cattype_name as cattypeName
from 
coz_order_gyv2_kpi t
where t.gyv2re_stalog_guid=''{orgStalogST2Guid}'' and (t.category_name  like ''%{categoryName}%'' or ''{categoryName}''='''')
group by t.category_name,t.cattype_name
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;