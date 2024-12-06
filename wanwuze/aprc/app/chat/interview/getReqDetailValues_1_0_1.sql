-- ##Title app-查询应聘信息内容详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询应聘信息内容详情
-- ##CallType[QueryData]

-- ##input deRequestGuid char[36] NOTNULL;应聘需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t.fd_name as fdName
,case when(t.fd_name='工作地点') then (select path_name from sys_city_code where code=t.fd_value limit 1) else t.fd_value end as value
from
coz_chat_demand_request_detail t
left join
coz_chat_demand_request t1
on t.de_request_guid=t1.guid
where 
t.de_request_guid='{deRequestGuid}' and t.status='1' and t1.status='1'