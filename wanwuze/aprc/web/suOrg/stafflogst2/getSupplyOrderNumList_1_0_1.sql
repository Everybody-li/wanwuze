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
orderNum
,t2.name as categoryName
,t2.cattype_name as cattypeName
from
(
select 
count(1) as orderNum
,cattype_guid
,category_guid
from 
coz_serve_order_kpi t
where t.supply_org_stalog_st2_guid=''{orgStalogST2Guid}'' and t.del_flag=''0'' and (t.category_name  like ''%{categoryName}%'' or ''{categoryName}''='''')
group by t.cattype_guid,t.category_guid
)t1
left join
coz_category_info t2
on t1.category_guid=t2.guid
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;