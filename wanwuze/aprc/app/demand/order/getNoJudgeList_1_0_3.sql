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
,case when (supply_done_flag=''0'' or Chile_supply_done_flag=''0'') then ''1'' else ''0'' end as cancelBtnFlag
,case when(Chile_supply_done_flag=''1'' and supply_done_flag=''1'') then ''1'' else ''0'' end as refundBtnFlag
,case when(Chile_supply_done_flag=''1'' and supply_done_flag=''1'') then ''1'' else ''0'' end as acceptBtnFlag
,case when (Chile_supply_done_flag=''0'') then ''1'' else ''0'' end as relatedCancelFlag
,case when (Chile_supply_done_flag=''1'') then concat(''【'',categoryName,''】\n采购编号:【'',orderNo,''】\n该笔订单的完成需要有物流等第3方品类支撑才能完成。现在第3方品类在交付中，不能取消订单。'') else '''' end as relatedCancelMsg
,judgeFlag
,case when (judgeFlag=''1'') then concat(''【'',categoryName,''】\n采购编号:【'',orderNo,''】\n处于交易仲裁，在【订单状态管理】中可见。'') else '''' end as judgeMsg
from
(
select 
t.guid as orderGuid
,t3.category_name as categoryName
,t3.category_img as categoryImg
,t3.category_alias as categoryAlias
,left(t.create_time,10) as orderTime
,t.order_no as orderNo
,(select count(1) from coz_order_outcome where order_guid=t.guid and del_flag=''0'') as hasOutcome
,t.need_deliver_flag
,t.supply_done_flag
,case when (exists(select 1 from coz_order where supply_done_flag=''0'' and parent_guid=t.guid and del_flag=''0'')) then ''0'' else ''1'' end Chile_supply_done_flag
,case when (exists(select 1 from coz_order_judge where order_guid=t.guid and result<>''3'' and del_flag=''0'')) then ''1'' else ''0'' end judgeFlag
,t.id
from  
coz_order t
inner join
coz_demand_request t3
on t.request_guid=t3.guid
where 
t.demand_user_id=''{curUserId}'' and t.del_flag=''0'' and t.accept_status=''0'' and t.parent_guid='''' and (not exists(select 1 from coz_order_judge where order_guid=t.guid and del_flag=''0'') or exists(select 1 from coz_order_judge where (result=''3'' or demand_read_flag=''0'') and order_guid=t.guid and del_flag=''0'') ) and not exists(select 1 from coz_order where guid=t.parent_guid and del_flag=''0'') and t.pay_status=''2'' and t3.sd_path_guid=''{sdPathGuid}''
)t
order by id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;