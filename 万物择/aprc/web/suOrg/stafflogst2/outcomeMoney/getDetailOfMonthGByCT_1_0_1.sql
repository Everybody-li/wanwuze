-- ##Title web-查询关联的供应机构月份采购服务费用品类列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询关联的供应机构月份采购服务费用品类列表
-- ##CallType[ExSql]

-- ##input month char[2] NOTNULL;结算机构guid，必填
-- ##input year char[4] NOTNULL;结算机构guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select
t.supplyOrgStalogST3Guid
,t.money
,t1.name as categoryName
,t.category_guid as categoryGuid
,t1.cattype_name as cattypeName
,t1.cattype_guid as cattypeGuid
from
(
select
t2.guid as supplyOrgStalogST3Guid
,cast(ifnull(sum(t1.money),0.00)/100 as decimal(18,2)) as money
,t1.category_guid
,t1.cattype_guid
from coz_serve_order_kpi t1 inner join coz_org_relate_staff_log t2 
on t1.supply_org_stalog_st2_guid=t2.guid and t2.staff_type=''2''
where
t1.supply_gauser_id=''{curUserId}'' and t1.year=''{year}'' and t1.month=''{month}'' and t1.del_flag=''0'' and t2.del_flag=''0''
group by t1.supply_seorg_stalog_st3_guid,t1.year,t1.month,t1.category_guid,t1.cattype_guid
)t left join coz_category_info t1
on t.category_guid=t1.guid
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;