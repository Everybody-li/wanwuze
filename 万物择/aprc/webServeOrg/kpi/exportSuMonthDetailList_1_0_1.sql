-- ##Title web-查询采购对接业绩年度详情(月份列表）
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询采购对接业绩年度详情(月份列表）
-- ##CallType[QueryData]

-- ##input year string[4] NOTNULL;登录用户id，必填
-- ##input month string[2] NOTNULL;登录用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
left(t1.create_time,16) as 加入机构日期
,left(t2.create_time,16) as 账号开通日期
,t2.user_name as 姓名
,t2.nation as `国家|地区`
,t2.phonenumber as 手机号
,concat(t.year,'-',t.month) as 月份
,t.money as 采购服务费用
from
(
select 
t.year
,t.month
,t.supply_seorg_guid
,t.supply_seorg_stalog_st2_guid
,cast(sum(t.money)/100 as decimal(18,2)) as money
from 
coz_serve_order_kpi t
where t.supply_seorg_guid='{curUserId}' and t.year='{year}' and t.month='{month}' and t.del_flag='0'
group by t.supply_seorg_guid,t.supply_seorg_stalog_st2_guid,t.year,t.month
)t
inner join
coz_serve_org_relate_staff_log t1
on t.supply_seorg_stalog_st2_guid=t1.guid
inner join
sys_app_user t2
on t1.staff_user_id=t2.guid
order by t.month desc
