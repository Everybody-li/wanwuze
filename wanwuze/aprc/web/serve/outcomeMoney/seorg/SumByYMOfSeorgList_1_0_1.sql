-- ##Title web-按月份统计招募专员用户的采购服务费用列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-按月份统计招募专员用户的采购服务费用列表
-- ##CallType[QueryData]

-- ##input year string[4] NOTNULL;登录用户id，必填
-- ##input month string[2] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input seorgName string[50] NULL;品类名称，非必填

PREPARE p1 FROM '
select
t2.user_name as seorgName
,left(t2.create_time,16) as registerTime
,''{year}-{month}'' as SettlementTime
,t1.demandMoney
,t1.supplyMoney
from
(
select 
t.seorgGuid
,sum(t.demandMoney) as demandMoney
,sum(t.supplyMoney) as supplyMoney
from
(
select 
demand_seorg_guid as seorgGuid
,cast(sum(t1.money)/100 as decimal(18,2)) as demandMoney
,0.00 as supplyMoney
from 
coz_serve_order_kpi t1
where t1.year=''{year}'' and t1.month=''{month}'' and length(t1.demand_seorg_guid)>1 and t1.del_flag=''0''
group by demand_seorg_guid
union all
select 
supply_seorg_guid as userId
,0.00 as demandMoney
,cast(sum(t1.money)/100 as decimal(18,2)) as supplyMoney
from 
coz_serve_order_kpi t1
where t1.year=''{year}'' and t1.month=''{month}'' and length(t1.supply_seorg_guid)>1 and t1.del_flag=''0''
group by supply_seorg_guid
)t
group by t.seorgGuid
)t1
inner join
coz_serve_org t2
on t1.seorgGuid=t2.guid
where 
(t2.user_name like ''%{seorgName}%'' or ''{seorgName}''='''')
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;
