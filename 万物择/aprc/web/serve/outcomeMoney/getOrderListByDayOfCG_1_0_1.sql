-- ##Title app-查询服务业绩统计的月份详情列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-服务成果统计-查询采购成果详情
-- ##CallType[QueryData]

-- ##input acceptDay string[10] NOTNULL;登录用户id，必填
-- ##input orderNo string[50] NULL;登录用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input categoryGuid char[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select
left(t2.accept_time,16) as acceptTime
,left(t2.create_time,10) as OrderTime
,t2.order_no as orderNo
,cast(t1.money/100 as decimal(18,2)) as money
,t1.order_guid as orderGuid
from
coz_serve_order_kpi t1
inner join
coz_order t2
on t1.order_guid=t2.guid
where
left(t1.create_time,10)=''{acceptDay}'' and t1.category_guid=''{categoryGuid}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and (t2.order_no like ''%{orderNo}%'' or ''{orderNo}''='''')
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;