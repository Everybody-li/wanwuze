-- ##Title web-查询交易收入管理-按年度统计
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询交易收入管理-按年度统计
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input serveFeeFlag string[1] NOTNULL;服务收费标志(0-免费，1-收费)，必填


select 
left(t1.create_time,4) as year
,cast(sum(case when('{serveFeeFlag}'='0') then t1.supply_fee else t1.demand_service_fee end)/100 as decimal(18,2)) as money
from 
coz_order t1
inner join
coz_demand_request t2
on t1.request_guid=t2.guid
where t1.del_flag='0' and t2.del_flag='0' and t2.serve_fee_flag='{serveFeeFlag}' and t1.pay_status='2'and t1.accept_status='1' 
group by left(t1.create_time,4)
order by left(t1.create_time,4) desc