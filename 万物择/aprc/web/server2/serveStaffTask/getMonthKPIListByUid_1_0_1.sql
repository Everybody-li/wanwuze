-- ##Title web-查看服务专员成果管理
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看服务专员成果管理
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
month
,sum(ifnull(targetObjectNum,0)) as targetObjectNum
,sum(ifnull(orderPayNum,0)) as orderPayNum
,sum(ifnull(activateAccountNum,0)) as activateAccountNum
from
(
select 
left(t1.create_time,7) as month
,0 as targetObjectNum
,count(t1.guid) as orderPayNum
,0 as activateAccountNum
from 
coz_order_serve2_source t1
where 
t1.serve_staff_user_id='{curUserId}' 
group by left(t1.create_time,7)
union all
select 
left(t2.account_time,7) as month
,0 as targetObjectNum
,0 as orderPayNum
,count(t2.guid) as activateAccountNum
from 
coz_org_info t2
inner join
sys_user t3
on t3.user_id=t2.account_by
where 
t2.del_flag='0' and t3.del_flag='0' and t3.status='0'  and t2.account_by='{curUserId}' 
group by left(t2.account_time,7)
)t
group by month
order by month desc