-- ##Title web-查询关联的服务机构月份采购服务费用订单列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询关联的服务机构月份采购服务费用订单列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input orderNo string[50] NULL;采购订单编号(模糊搜索)，非必填
-- ##input supplyOrgStalogST2Guid char[36] NOTNULL;供应专员与供应机构关联guid，必填
-- ##input categoryGuid char[36] NOTNULL;供应专员与供应机构关联guid，必填
-- ##input cattyeGuid char[36] NOTNULL;供应专员与供应机构关联guid，必填
-- ##input month char[2] NOTNULL;月份，必填
-- ##input year char[4] NOTNULL;年度，必填

PREPARE p1 FROM '
select 
cast(t1.money/100 as decimal(18,2)) as money
,t2.order_no as orderNo
,left(t2.create_time,16) as createTime
,left(t2.accept_time,16) as acceptTime
from 
coz_serve_order_kpi t1
inner join
coz_order t2
on t1.order_guid=t2.guid
where t1.supply_org_stalog_st2_guid=''{supplyOrgStalogST2Guid}'' and t1.year=''{year}'' and t1.month=''{month}'' and t1.category_guid=''{categoryGuid}'' and t1.cattype_guid=''{cattyeGuid}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and (t2.order_no like ''%{orderNo}%'' or ''{orderNo}''='''')
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;