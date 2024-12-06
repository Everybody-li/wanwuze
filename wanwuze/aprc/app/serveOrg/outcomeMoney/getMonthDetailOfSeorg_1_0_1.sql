-- ##Title app-查询服务业绩统计的月份详情列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-查询服务业绩统计的月份详情列表
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input month char[2] NOTNULL;结算机构guid，必填
-- ##input year char[4] NOTNULL;结算机构guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
t2.user_name as seorgName
,left(t1.create_time,16) as relateTime
,(select cast(ifnull(sum(money),0.00)/100 as decimal(18,2)) from coz_serve_order_kpi where demand_seorg_stalog_st1_guid=t1.guid and del_flag=''0'' and year=''{year}'' and month=''{month}'') as money
from
coz_serve_org_relate_staff_log t1
inner join
coz_serve_org t2
on t1.seorg_guid=t2.guid
where
t1.staff_type=''1''  and t1.staff_user_id=''{curUserId}'' and t1.del_flag=''0''
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;