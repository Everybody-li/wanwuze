-- ##Title web-查询变更记录
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询变更记录
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
t1.category_guid as categoryGuid
,t2.name as categoryName
,t.day
,left(t.create_time,10) as createTime
from
coz_category_deal_deadline_log t
left join
coz_category_deal_deadline t1
on t.deadline_guid=t1.guid
left join
coz_category_info t2
on t1.category_guid=t2.guid
where t1.category_guid='{categoryGuid}'
order by t.create_time desc