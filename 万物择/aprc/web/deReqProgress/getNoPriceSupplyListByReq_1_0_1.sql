-- ##Title web-查询需求的未报价供应机构列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询需求的未报价供应机构列表
-- ##CallType[QueryData]

-- ##input demandRequestGuid char[36] NOTNULL;服务对象guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select 
t1.guid as requestSupplyGuid
,left(t3.create_time,16) as registerTime
,t3.name as orgName
,left(t3.create_time,16) as orgCreateTime
,concat(''(+86)'',t3.phonenumber) as orgPhone
,t6.login_sysname as orgLoginName
,t4.recommend_type as recomendType
from 
coz_demand_request_supply t1
inner join
coz_category_supplier t2
on t1.supplier_guid=t2.guid
inner join
coz_org_info t3
on t2.user_id=t3.user_id
inner join
coz_demand_request_match_notice t4
on t1.guid=t4.request_supply_guid
inner join
coz_category_info t5
on t2.category_guid=t5.guid
inner join
coz_lgcode_fixed_data t6
on t5.login_code=t6.login_code
where 
t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t4.del_flag=''0'' and t5.del_flag=''0'' and t6.del_flag=''0'' and t1.request_guid=''{demandRequestGuid}'' and (t1.price_status=''1'' or t1.price_status=''2'' or t1.price_status=''4'')
order by t1.price_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;