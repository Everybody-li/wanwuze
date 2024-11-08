-- ##Title web-供应-(非实物产品/取消订单)自动办理退货
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-供应-(非实物产品/取消订单)自动办理退货
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @flag1=(select case when (exists(select 1 from coz_order_refund where order_guid='{orderGuid}' and supply_accept='1' and del_flag='0') or exists(select 1 from coz_order_cancel where order_guid='{orderGuid}' and supply_done_flag='1' and del_flag='0')) then '0' else '1' end)
;
update coz_order_refund
set supply_accept_way='2'
,supply_accept_user_id='{curUserId}'
,supply_accept='1'
,update_by='{curUserId}'
,update_time=now()
where 
order_guid='{orderGuid}' and supply_accept<>'1' and @flag1='1'
;
update coz_order_cancel
set supply_done_flag='1'
,supply_done_time=now()
,supply_done_way='2'
,update_by='{curUserId}'
,update_time=now()
where 
order_guid='{orderGuid}' and supply_done_flag='0' and @flag1='1'
;
insert into coz_order_operation_log(guid,order_guid,last_status,status,operate_object,remark,create_by,create_time)
select
uuid()
,'{orderGuid}'
,ifnull((select status from coz_order_operation_log where order_guid='{orderGuid}' order by create_time desc limit 1),'0')
,'9'
,'2'
,''
,'{curUserId}'
,now()
from
coz_order 
where 
guid='{orderGuid}' and @flag1='1'
limit 1
;
select 
case when(@flag1='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '当前订单供方已经验收通过，无需再操作验收事宜'  else '操作成功' end as msg