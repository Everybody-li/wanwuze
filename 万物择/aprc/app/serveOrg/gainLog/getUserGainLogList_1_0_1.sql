-- ##Title app-对象领取统计
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-对象领取统计
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select 
left(t1.create_time,10) as createTime
,count(1) as gainNum
from 
coz_serve_user_gain_log t1
inner join
coz_serve_org_relate_staff_log t2
on t1.seorg_stalog_st1_guid=t2.guid
where t2.staff_user_id=''{curUserId}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and t2.staff_type=''1''
group by left(t1.create_time,10)
order by left(t1.create_time,10) desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;