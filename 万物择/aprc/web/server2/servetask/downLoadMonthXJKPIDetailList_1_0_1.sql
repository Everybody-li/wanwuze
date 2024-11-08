-- ##Title web-查询服务调度专员处的询价专员成果(月份详情列表)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务调度专员处的询价专员成果(月份详情列表)
-- ##CallType[QueryData]

-- ##input month string[7] NOTNULL;月份(格式：0000-00)，必填
-- ##input phonenumber string[11] NULL;联系电话，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
userName as 用户账号名称
,nickName as 用户姓名
,phonenumber as 联系电话
,concat('`',month,'`') as 月份
,sum(ifnull(demandRequestNum,0)) as 采购需求提交
,sum(ifnull(demandRequestSupplyNum,0)) as 采购供应报价
,sum(ifnull(AcceptedNum,0)) as 验收通过数量
from
(
select 
t3.user_name as userName
,t3.nick_name as nickName
,concat('(+86)',t3.phonenumber) as phonenumber
,left(t1.request_time,7) as month
,count(t1.guid) as demandRequestNum
,0 as demandRequestSupplyNum
,0 as AcceptedNum
from 
coz_demand_request_serve2_source t1
inner join
sys_user t3
on t1.aprice_staff_user_id=t3.user_id
where 
t3.del_flag='0' and t3.status='0' and left(t1.request_time,7)='{month}' and (t3.phonenumber  like '%{phonenumber}%' or '{phonenumber}'='')
group by left(t1.request_time,7),t3.user_name,t3.nick_name,t3.phonenumber
union all
select 
t3.user_name as userName
,t3.nick_name as nickName
,concat('(+86)',t3.phonenumber) as phonenumber
,left(t2.price_time,7) as month
,0 as demandRequestNum
,count(t2.guid) as demandRequestSupplyNum
,0 as AcceptedNum
from 
coz_demand_request_supply_serve2_source t2
inner join
sys_user t3
on t2.aprice_staff_user_id=t3.user_id
where 
t3.del_flag='0' and t3.status='0' and left(t2.price_time,7)='{month}' and (t3.phonenumber  like '%{phonenumber}%' or '{phonenumber}'='')
group by left(t2.price_time,7),t3.user_name,t3.nick_name,t3.phonenumber
union all
select 
t5.user_name as userName
,t5.nick_name as nickName
,concat('(+86)',t5.phonenumber) as phonenumber
,left(t3.accept_time,7) as month
,0 as demandRequestNum
,0 as demandRequestSupplyNum
,count(t4.guid) as AcceptedNum
from 
coz_order t3
inner join
coz_order_serve2_source t4
on t3.guid=t4.order_guid
inner join
sys_user t5
on t4.aprice_staff_user_id=t5.user_id
where 
t3.del_flag='0' and t5.del_flag='0' and t5.status='0' and t3.accept_status='1' and left(t3.accept_time,7)='{month}' and (t5.phonenumber  like '%{phonenumber}%' or '{phonenumber}'='')
group by left(t3.accept_time,7),t5.user_name,t5.nick_name,t5.phonenumber
)t
group by month,userName,nickName,phonenumber
order by month desc