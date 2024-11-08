-- ##Title app-对象领取统计
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-对象领取统计

-- ##input curUserId string[36] NOTNULL;用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
*
,(select count(1) from coz_guidance_user_record where user_id=''{curUserId}'' and left(create_time,10)=t.createTime and take_back_flag=0) as validNum
from
(
select 
count(1) as collectNum

,left(create_time,10) as createTime
from 
coz_guidance_user_record_log
where user_id=''{curUserId}'' 
group by left(create_time,10)
)t
order by createTime desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;