-- ##Title web-查询供应专员业绩管理-供应专员成果报表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供应专员业绩管理-供应专员成果报表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input serveFeeFlag string[1] NOTNULL;登录用户id，必填
-- ##input gyv2UserId string[36] NULL;登录用户id，必填
-- ##input year string[4] NOTNULL;年度(格式：0000)，必填
-- ##input month string[2] NOTNULL;月份(格式：00)，必填
-- ##input OutputFileName string[100] NOTNULL;报表名称(order+年月日时分秒,例:order20220622090321)，必填

select 
*
from
(
select 
concat('`{year}','-','{month}`') as 月份
,concat('(+86)',t2.phonenumber) as 联系电话
,t2.user_name as 账号名称
,case when(t2.del_flag='0') then t2.nick_name else concat(t2.nick_name,'(已删除)') end as 姓名
,t1.money as 采购服务费用
from
(
select 
cast(sum(t1.money)/100 as decimal(18,2)) as money
,t1.gyv2staff_user_id as userId
from 
coz_order_gyv2_kpi t1
inner join
sys_user t2
on t1.gyv2staff_user_id=t2.user_id
where 
t1.serve_fee_flag='{serveFeeFlag}' and (t1.gyv2staff_user_id='{gyv2UserId}' or '{gyv2UserId}'='') and t1.year='{year}' and t1.month='{month}' and (t2.phonenumber like '%{phonenumber}%' or '{phonenumber}'='')
group by t1.gyv2staff_user_id
)t1
inner join
sys_user t2
on t1.userId=t2. user_id
)t
order by 月份 desc