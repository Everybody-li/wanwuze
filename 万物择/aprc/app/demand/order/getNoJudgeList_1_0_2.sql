-- ##Title app-采购-查询成果交接管理列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-查询成果交接管理列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;供方用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径关联guid，必填


PREPARE q1 FROM '
select
categoryName
,categoryalias
,categoryImg
,orderTime
,orderNo
,orderGuid
,hasOutcome
,case when (supply_done_flag=''0'') then ''1'' else ''0'' end as cancelBtnFlag
,case when(Chile_supply_done_flag=''1'' and supply_done_flag=''1'') then ''1'' else ''0'' end as refundBtnFlag
,case when(Chile_supply_done_flag=''1'' and supply_done_flag=''1'') then ''1'' else ''0'' end as acceptBtnFlag
,relatedCancelFlag
from
(
select 
t2.guid as orderGuid
,t3.name as categoryName
,t3.img as categoryImg
,t3.alias as categoryAlias
,left(t2.create_time,10) as orderTime
,t2.order_no as orderNo
,(select count(1) from coz_order_outcome where order_guid=t2.guid and pay_status=''2'') as hasOutcome
,t2.need_deliver_flag
,t2.supply_done_flag
,case when (exists(select 1 from coz_order where supply_done_flag=0 and (parent_guid=t2.guid or parent_guid in(select guid from coz_order where parent_guid=t2.guid)) and del_flag=0)) then ''0'' else ''1'' end Chile_supply_done_flag
,case when (exists(select 1 from coz_order_cancel a where a.del_flag=''0'' and exists(select 1 from coz_order where guid=t2.parent_guid and guid=a.order_guid and del_flag=''0''))) then ''1'' else ''0'' end as relatedCancelFlag
,case when ( (not exists(select 1 from coz_order_judge where order_guid=t2.guid and del_flag=''0'') or exists(select 1 from coz_order_judge where order_guid=t2.guid and del_flag=''0'' and result=''3'')) and (exists(select 1 from coz_order_judge where order_guid=t2.parent_guid and del_flag=''0'' and result<>''3'') or exists(select 1 from coz_order_judge where order_guid in (select guid from coz_order where parent_guid=t2.guid) and del_flag=''0'' and result<>''3''))) then concat(t3.name,''\n采购编号:'',t2.order_no,''\n处于交易仲裁，在【订单状态管理】中可见。'') else '''' end as relatedCancelMsg
from  
coz_order t2
left join 
coz_category_info t3
on t2.category_guid=t3.guid 
where 
t2.demand_user_id=''{curUserId}'' and t2.del_flag=''0'' and t2.accept_status=''0''  and not exists(select 1 from coz_order_judge where result<>''3'' and order_guid=t2.guid and del_flag=''0'') and not exists(select 1 from coz_order where guid=t2.parent_guid and del_flag=''0'') and t2.pay_status=''2'' and t2.demand_read_cancel_flag<>''2'' and t2.sd_path_guid=''{sdPathGuid}''
)t
order by orderTime desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;