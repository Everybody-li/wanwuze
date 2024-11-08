-- ##Title app-供应-查询退货交接订单列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-查询退货交接订单列表
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NULL;采购供应路径关联guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select
*
from
(
select 
t2.guid as judgeGuid
,t3.supply_user_id as supplyUserId
,t2.result as judgeResult
,t1.order_guid as orderGuid
,t3.order_no as orderNo
,t1.guid as orderRefundGuid
,'''' as orderCancelGuid
,left(t3.create_time,10) as orderTime
,t4.guid as categoryGuid
,t4.img as categoryImg
,t4.name as categoryName
,t4.alias as categoryAlias
,case when (t3.need_deliver_flag=''1'') then ''1'' else ''0'' end as orderCatVirtualFlag
,concat(''【'',t4.name,''】<br>采购编号:【'',t3.order_no,''】<br>本订单退货办理，系统自动办理完成。默认供方验收通过。点击【我知道了】后在【订单状态管理】了解进度。'') as autoSubmitRefundProvMsg
from 
coz_order_refund t1
left join 
coz_order_judge t2
on t2.biz_guid=t1.guid 
left join 
coz_order t3 
on t1.order_guid=t3.guid 
left join 
coz_category_info t4
on t3.category_guid=t4.guid 
where 
t3.supply_user_id=''{curUserId}'' and t3.sd_path_guid=''{sdPathGuid}''  and t1.supply_accept=''0'' and t2.result in (''1'',''2'',''4'')
union all
select 
t2.guid as judgeGuid
,t3.supply_user_id as supplyUserId
,t2.result as judgeResult
,t1.order_guid as orderGuid
,t3.order_no as orderNo
,'''' as orderRefundGuid
,t1.guid as orderCancelGuid
,left(t3.create_time,10) as orderTime
,t4.guid as categoryGuid
,t4.img as categoryImg
,t4.name as categoryName
,t4.alias as categoryAlias
,case when (exists(select 1 from coz_order_refund where order_guid=t1.order_guid) and t3.need_deliver_flag=''1'') then ''1'' else ''0'' end as orderCatVirtualFlag
,concat(''【'',t4.name,''】<br>采购编号:【'',t3.order_no,''】<br>本订单退货办理，系统自动办理完成。默认供方验收通过。点击【我知道了】后在【订单状态管理】了解进度。'') as autoSubmitRefundProvMsg
from 
coz_order_cancel t1
left join 
coz_order_judge t2
on t2.biz_guid=t1.guid 
left join 
coz_order t3 
on t1.order_guid=t3.guid 
left join 
coz_category_info t4
on t3.category_guid=t4.guid 
where 
t3.supply_user_id=''{curUserId}'' and t3.sd_path_guid=''{sdPathGuid}'' and t1.supply_done_flag=''0'' and t2.result in (''1'',''2'',''4'')
)t
order by orderTime desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;