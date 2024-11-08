-- ##Title app-服务成果统计-查询采购成果详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-服务成果统计-查询采购成果详情
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input demandUserId char[36] NOTNULL;采购订单用户id(即服务对象用户id)，必填
-- ##input demandSeorgStalogST1Guid char[36] NULL;服务机构与服务专员关联记录guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select
left(t2.accept_time,16) as acceptTime
,left(t2.create_time,10) as OrderTime
,t3.category_name as categoryName
,t3.cattype_name as cattypeName
,t2.order_no as orderNo
from
coz_serve_order_kpi t1
inner join
coz_order t2
on t1.order_guid=t2.guid
inner join
coz_demand_request t3
on t2.request_guid=t3.guid
where
t2.demand_user_id=''{demandUserId}'' and t1.demand_seorg_stalog_st1_guid=''{demandSeorgStalogST1Guid}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0''
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;