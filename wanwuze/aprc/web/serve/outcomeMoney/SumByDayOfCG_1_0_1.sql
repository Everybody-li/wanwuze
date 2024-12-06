-- ##Title ﻿﻿web-根据年度按月份查询服务业绩统计
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe ﻿﻿web-根据年度按月份查询服务业绩统计
-- ##CallType[QueryData]

-- ##input acceptDay string[10] NOTNULL;登录用户id，必填
-- ##input categoryName string[50] NULL;登录用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input cattypeGuid char[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
t.category_guid as categoryGuid
,t.money
,t1.name as categoryName
,t1.cattype_name as cattypeName
from
(
select 
t.category_guid
,cast(sum(t.money)/100 as decimal(18,2)) as money
from 
coz_serve_order_kpi t
where left(t.create_time,10)=''{acceptDay}'' and t.del_flag=''0'' and t.cattype_guid=''{cattypeGuid}'' and (t.category_name like ''%{categoryName}%'' or ''{categoryName}''='''')
group by t.category_guid
)t
inner join
coz_category_info t1
on t.category_guid=t1.guid
order by t1.id
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;