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
-- ##input phonenumber string[50] NULL;品类名称，非必填


select
t2.user_name as 账号名称
,left(t2.create_time,16) as 账号创建日期
,t2.nick_name as 姓名
,t2.nation as `国家/地区`
,t2.phonenumber as 手机号
,'{year}|{month}' as 计酬月份
,t1.demandMoney as 采购对接采购服务费用
,t1.supplyMoney as 供应对接采购服务费用
from
(
select 
t.userId
,sum(t.demandMoney) as demandMoney
,sum(t.supplyMoney) as supplyMoney
from
(
select 
demand_st3_user_id as userId
,cast(sum(t1.money)/100 as decimal(18,2)) as demandMoney
,0.00 as supplyMoney
from 
coz_serve_order_kpi t1
where t1.year='{year}' and t1.month='{month}' and length(t1.demand_st3_user_id)>1 and t1.del_flag='0'
group by demand_st3_user_id
union all
select 
supply_st3_user_id as userId
,0.00 as demandMoney
,cast(sum(t1.money)/100 as decimal(18,2)) as supplyMoney
from 
coz_serve_order_kpi t1
where t1.year='{year}' and t1.month='{month}' and length(t1.supply_st3_user_id)>1 and t1.del_flag='0'
group by supply_st3_user_id
)t
group by t.userId
)t1
inner join
sys_user t2
on t1.userId=t2.user_id
where 
(t2.user_name like '%{phonenumber}%' or t2.phonenumber like '%{phonenumber}%' or '{phonenumber}'='')
order by t2.create_time desc

