-- ##Title ﻿app-对象收回统计
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe ﻿app-对象收回统计
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select
*
,(select count(1) from coz_serve_user_gain_log where left(create_time,10)=t.createTime and del_flag=''0'' and user_id=''{curUserId}'') as gainNum
from
(
select 
left(t1.create_time,10) as createTime
,count(1) as takebackNum
from 
coz_serve_user_gain_log t1
where left(t1.takeback_time,10)=''{takebackTime}'' and t1.del_flag=''0'' and t1.user_id=''{curUserId}''
group by left(t1.create_time,10)
)t
order by t.createTime desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;