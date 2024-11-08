-- ##Title web-供应机构用户-查询供应成果列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-供应机构用户-查询供应成果列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input userId string[36] NOTNULL;供应机构用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select
t3.category_guid as categoryGuid
,t3.category_name as categoryName
,t3.cattype_name as cattypeName
,t3.cattype_guid as cattypeGuid
,count(1) as orderNum
from
coz_order_serve2_source t1
inner join
coz_order t2
on t1.order_guid=t2.guid
inner join
coz_demand_request t3
on t2.request_guid=t3.guid
where 
t2.demand_user_id=''{userId}'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t2.accept_status=''1''
group by t3.category_guid,t3.category_name,t3.cattype_name,t3.cattype_guid
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;

