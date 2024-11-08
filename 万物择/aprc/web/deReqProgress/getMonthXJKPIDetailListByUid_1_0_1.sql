-- ##Title web-查看沟通专员成果详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看沟通专员成果详情
-- ##CallType[QueryData]

-- ##input month string[7] NOTNULL;月份(格式：0000-00)，必填
-- ##input categoryName string[200] NULL;联系电话，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select
cattypeName
,categoryName
,month
,sum(ifnull(demandRequestNum,0)) as demandRequestNum
,sum(ifnull(demandRequestSupplyNum,0)) as demandRequestSupplyNum
,sum(ifnull(AcceptedNum,0)) as AcceptedNum
from
(
select 
t1.cattype_name as cattypeName
,t1.category_name as categoryName
,left(t1.create_time,7) as month
,count(t1.guid) as demandRequestNum
,0 as demandRequestSupplyNum
,0 as AcceptedNum
from 
coz_demand_request t1
inner join
coz_server2_sys_user_category t4
on t1.category_guid=t4.category_guid
where 
t1.del_flag=''0'' and t4.del_flag=''0'' and t4.user_id=''{curUserId}'' and left(t1.create_time,7)=''{month}'' and (t1.category_name  like ''%{categoryName}%'' or ''{categoryName}''='''')
group by left(t1.create_time,7),t1.cattype_name,t1.category_name
union all
select 
t1.cattype_name as cattypeName
,t1.category_name as categoryName
,left(t2.price_time,7) as month
,0 as demandRequestNum
,count(t2.guid)  as demandRequestSupplyNum
,0 as AcceptedNum
from 
coz_demand_request t1
inner join
coz_server2_sys_user_category t4
on t1.category_guid=t4.category_guid
inner join
coz_demand_request_supply t2
on t1.guid=t2.request_guid
where 
t1.del_flag=''0'' and t2.del_flag=''0'' and t4.del_flag=''0'' and t2.price_status=''3'' and t4.user_id=''{curUserId}'' and left(t2.price_time,7)=''{month}'' and (t1.category_name  like ''%{categoryName}%'' or ''{categoryName}''='''')
group by left(t2.price_time,7),t1.cattype_name,t1.category_name
union all
select 
t1.cattype_name as cattypeName
,t1.category_name as categoryName
,left(t3.accept_time,7) as month
,0 as demandRequestNum
,0  as demandRequestSupplyNum
,count(t3.guid) as AcceptedNum
from 
coz_demand_request t1
inner join
coz_server2_sys_user_category t4
on t1.category_guid=t4.category_guid
inner join
coz_order t3
on t1.guid=t3.request_guid
where 
t1.del_flag=''0'' and t3.del_flag=''0'' and t4.del_flag=''0'' and t3.accept_status=''1'' and t4.user_id=''{curUserId}'' and left(t3.accept_time,7)=''{month}'' and (t1.category_name  like ''%{categoryName}%'' or ''{categoryName}''='''')
group by left(t3.accept_time,7),t1.cattype_name,t1.category_name
)t
group by cattypeName,categoryName,month
order by month desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;