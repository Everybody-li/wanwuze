-- ##Title web-查询交易收入管理-某日期下的订单详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询交易收入管理-某日期下的订单详情
-- ##CallType[QueryData]

-- ##input day string[10] NOTNULL;日期(格式0000-00-00)，必填
-- ##input orderNo string[50] NULL;登录用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input categoryGuid char[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input serveFeeFlag string[1] NOTNULL;服务收费标志(0-免费，1-收费)，必填

PREPARE q1 FROM '
select
left(t1.accept_time,16) as acceptTime
,left(t1.create_time,10) as OrderTime
,t1.order_no as orderNo
,case when(''{serveFeeFlag}''=''0'') then cast(t1.supply_fee/100 as decimal(18,2)) else cast(t1.demand_service_fee/100 as decimal(18,2)) end as money
,t1.guid as orderGuid
from
coz_order t1
inner join
coz_demand_request t2
on t1.request_guid=t2.guid
where
left(t1.create_time,10)=''{day}'' and t2.category_guid=''{categoryGuid}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and t2.serve_fee_flag=''{serveFeeFlag}'' and t1.pay_status=''2'' and t1.accept_status=''1'' and (t1.order_no like ''%{orderNo}%'' or ''{orderNo}''='''')
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;