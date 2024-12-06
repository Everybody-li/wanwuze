-- ##Title web-查询交易收入管理-日期详情(某日期下的品类详情)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询交易收入管理-日期详情(某日期下的品类详情)
-- ##CallType[QueryData]

-- ##input serveFeeFlag string[1] NOTNULL;服务收费标志(0-免费，1-收费)，必填
-- ##input day string[10] NOTNULL;登录用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input cattypeGuid string[36] NOTNULL;登录用户id，必填
-- ##input categoryName string[50] NULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select 
left(t1.create_time,10) as day
,t2.cattype_name as cattypeName
,t2.category_name as categoryName
,t3.guid as categoryGuid
,case when(''{serveFeeFlag}''=''0'') then cast(sum(t1.supply_fee)/100 as decimal(18,2)) else cast(sum(t1.demand_service_fee)/100 as decimal(18,2)) end as money
from 
coz_order t1
inner join
coz_demand_request t2
on t1.request_guid=t2.guid
inner join
coz_category_info t3
on t2.category_guid=t3.guid
where t1.del_flag=''0'' and t2.del_flag=''0'' and t2.serve_fee_flag=''{serveFeeFlag}'' and t1.pay_status=''2''and t1.accept_status=''1'' and left(t1.create_time,10)=''{day}'' and t2.cattype_guid=''{cattypeGuid}'' and (t2.category_name like ''%{categoryName}%'' or ''{categoryName}''='''')
group by left(t1.create_time,10),t3.guid,t2.cattype_name,t2.category_name
order by t3.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;