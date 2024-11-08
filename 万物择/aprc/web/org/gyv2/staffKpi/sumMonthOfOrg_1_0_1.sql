-- ##Title web-查询关联的供应机构月份采购服务费用品类列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询关联的供应机构月份采购服务费用品类列表
-- ##CallType[ExSql]

-- ##input serveFeeFlag string[1] NOTNULL;服务收费标志(0-免费，1-收费)，必填
-- ##input gyv2UserId string[36] NOTNULL;供应专员用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orgUserId char[36] NOTNULL;机构用户id
-- ##input year char[4] NOTNULL;结算机构guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
t.orgUserId
,t.money
,t.category_name as categoryName
,t.category_guid as categoryGuid
,t.cattype_name as cattypeName
,t.cattype_guid as cattypeGuid
from
(
select
t1.org_user_id as orgUserId
,cast(ifnull(sum(t1.money),0.00)/100 as decimal(18,2)) as money
,t1.category_guid
,t1.cattype_guid
,t1.category_name
,t1.cattype_name
from 
coz_order_gyv2_kpi t1
where
t1.gyv2staff_user_id=''{gyv2UserId}'' and t1.serve_fee_flag=''{serveFeeFlag}'' and t1.year=''{year}'' and t1.month=''{month}''  and t1.org_user_id=''{orgUserId}''
group by t1.org_user_id,t1.year,t1.month,t1.category_guid,t1.cattype_guid,t1.category_name,t1.cattype_name
)t 
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;