-- ##Title app-采购-判断是否可以取消订单
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-判断是否可以取消订单
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;供方用户id，必填

-- ##output canCancelFlag int[>=0] 1;（0：不可以取消，1：可以取消）

set @Flag1=(select case when(accept_status=0 and supply_done_flag=0) then '1' else '0' end  from coz_order where guid='{orderGuid}')
;
set @Flag2=(select case when not exists(select 1 from coz_order_cancel where order_guid='{orderGuid}' and cancel_user_id='{curUserId}' and del_flag=0) then '1' else '0' end  from coz_order where guid='{orderGuid}')
;
set @Flag3=(select case when (not exists(select 1 from coz_order where parent_guid='{orderGuid}' and del_flag='0' and supply_done_flag='0') and  not exists(select 1 from coz_order where guid=(select parent_guid from coz_order where guid='{orderGuid}') and del_flag=0 and supply_done_flag='0')  ) then '1' else '0' end)
;
select case when(@Flag1='1' and @Flag2='1' and @Flag3='1') then '1' else '0' end as canCancelFlag