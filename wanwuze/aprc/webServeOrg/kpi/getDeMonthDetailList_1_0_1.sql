-- ##Title web-查询采购对接业绩年度详情(月份列表）
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询采购对接业绩年度详情(月份列表）
-- ##CallType[QueryData]

-- ##input year string[4] NOTNULL;登录用户id，必填
-- ##input month string[2] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE p1 FROM '
select
left(t1.create_time,16) as bindOrgTime
,left(t2.create_time,16) as registerTime
,t2.user_name as userName
,t2.nation
,t2.phonenumber
,concat(t.year,''-'',t.month) as month
,t.money
from
(
select 
t.year
,t.month
,t.demand_seorg_guid
,t.demand_seorg_stalog_st1_guid
,cast(sum(t.money)/100 as decimal(18,2)) as money
from 
coz_serve_order_kpi t
where t.demand_seorg_guid=''{curUserId}'' and t.year=''{year}'' and t.month=''{month}'' and t.del_flag=''0''
group by t.demand_seorg_guid,t.demand_seorg_stalog_st1_guid,t.year,t.month
)t
inner join
coz_serve_org_relate_staff_log t1
on t.demand_seorg_stalog_st1_guid=t1.guid
inner join
sys_app_user t2
on t1.staff_user_id=t2.guid
order by t.month desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;
