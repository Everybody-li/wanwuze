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
t1.category_guid as categoryGuid
,t1.category_name as categoryName
,t1.cattype_name as cattypeName
,t1.cattype_guid as cattypeGuid
,count(1) as orderNum
from
coz_serve_order_kpi t1
where 
t1.demand_user_id=''{userId}'' and t1.del_flag=''0''
group by t1.category_guid,t1.category_name,t1.cattype_name,t1.cattype_guid
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;

