-- ##Title web-查询月份采购服务费用详情列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询月份采购服务费用详情列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input month char[2] NOTNULL;结算机构guid，必填
-- ##input year char[4] NOTNULL;结算机构guid，必填
-- ##input orgName string[50] NULL;机构名称（模糊搜索），非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
t3.name as orgName
,t3.guid as orgGuid
,left(t2.create_time,16) as relateTime
,left(t3.create_time,16) as registerTime
,(select cast(ifnull(sum(money),0.00)/100 as decimal(18,2)) from coz_serve_order_kpi where supply_org_stalog_st2_guid=t2.guid and del_flag=''0'' and year=''{year}'' and month=''{month}'' and supply_gauser_id=''{curUserId}'') as money
from
coz_org_relate_staff_log t2
inner join
coz_org_info t3
on t2.org_user_id=t3.user_id
where
t2.staff_user_id=''{curUserId}'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t2.staff_type=''2''
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

