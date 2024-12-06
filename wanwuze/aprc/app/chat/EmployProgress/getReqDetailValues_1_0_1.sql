-- ##Title app-招聘-招聘进展管理-邀约信息管理-邀约等待信息-查看应聘人员-上半部分
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询招聘信息内容详情
-- ##CallType[QueryData]

-- ##input deRequestGuid char[36] NOTNULL;招聘需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t.fd_name as fdName
,case when(t.fd_name='工作地点') then (select path_name from sys_city_code where code=t.fd_value limit 1) else t.fd_value end as value
from
coz_chat_supply_request_detail t
left join
coz_chat_supply_request t1
on t.de_request_guid=t1.guid
where 
t.de_request_guid='{deRequestGuid}' and t.status='1' and t1.status='1'