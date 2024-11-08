-- ##Title web-查询沟通任务派发管理-执行未开始
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询沟通任务派发管理-执行未开始
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select
*
from
(
select 
left(t1.start_date,10) as startDate
,left(t1.end_date,10) as endDate
,concat(left(t1.start_date,10),''---'',left(t1.end_date,10)) as taskDate
from 
coz_serve2_serve_task t1
where
t1.del_flag=''0'' and
t1.start_date>left(now(),10)
group by left(t1.start_date,10),left(t1.end_date,10),concat(left(t1.start_date,10),left(t1.end_date,10))
)t
order by t.taskDate desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;