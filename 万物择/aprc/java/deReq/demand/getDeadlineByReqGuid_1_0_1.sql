-- ##Title 需求-根据需求查询品类的验收期限
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 需求-根据需求查询品类的验收期限
-- ##CallType[QueryData]

-- ##input requestGuid char[36] NOTNULL;需求guid，必填
-- ##input curUserId string[36] NOTNULL;需方用户id，必填


select 
t2.day as deadlinDay
,t1.category_guid as categoryGuid
from  
coz_demand_request t1
left join
coz_category_deal_deadline_log t2
on t1.category_guid=t2.category_guid
where 
t1.guid='{requestGuid}'
order by t2.id desc
limit 1
