-- ##Title web-查询服务调度专员处的服务专员成果管理(月份汇总)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务调度专员处的服务专员成果管理(月份汇总)
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
month
from
(
select left(create_time,7) as month from coz_serve2_serve_task where del_flag=''0''
)t
group by month
order by month desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;