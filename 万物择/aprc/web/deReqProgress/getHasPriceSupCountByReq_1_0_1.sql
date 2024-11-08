-- ##Title web-查询需求的已报价供应机构总数
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询需求的已报价供应机构总数
-- ##CallType[QueryData]

-- ##input demandRequestGuid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
count(1) as totalCount
from 
coz_demand_request_supply t1
inner join
coz_category_supplier t2
on t1.supplier_guid=t2.guid
inner join
coz_org_info t3
on t2.user_id=t3.user_id
where 
t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and t1.request_guid='{demandRequestGuid}' and t1.price_status='3'