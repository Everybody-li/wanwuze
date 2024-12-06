-- ##Title web-供应-(非实物产品/取消订单)自动办理退货
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-供应-(非实物产品/取消订单)自动办理退货
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @flag1=(select case when exists(select 1 from coz_order where guid='{orderGuid}' and need_deliver_flag='1' and del_flag='0' and exists(select 1 from coz_order_refund where order_guid='{orderGuid}'and del_flag='0')) then '0' else '1' end)
;
set @flag2=(select case when (exists(select 1 from coz_order_refund where order_guid='{orderGuid}' and demand_refund_goods_opflag='2' and del_flag='0') or exists(select 1 from coz_order_cancel where order_guid='{orderGuid}'  and demand_done_flag='1' and del_flag='0')) then '0' else '1' end)
;
update coz_order_refund
set biz_rule_type23=(select guid from coz_order_bussiness_rule  where type = 23)
,demand_refund_goods_opflag='2'
,demand_refund_goods_opway='2'
,prove_logistic_time=now()
,prove_supply_sign_date=now()
,update_by='{curUserId}'
,update_time=now()
where 
order_guid='{orderGuid}' and demand_refund_goods_opflag='1' and @flag1='1' and @flag2='1'
;
update coz_order_cancel
set demand_done_flag='1'
,demand_done_time=now()
,update_by='{curUserId}'
,update_time=now()
where 
order_guid='{orderGuid}' and demand_done_flag='0' and @flag1='1' and @flag2='1'
;
insert into coz_order_operation_log(guid,order_guid,last_status,status,operate_object,remark,create_by,create_time)
select
uuid()
,'{orderGuid}'
,ifnull((select status from coz_order_operation_log where order_guid='{orderGuid}' order by create_time desc limit 1),'0')
,'7'
,'2'
,''
,'{curUserId}'
,now()
from
coz_order 
where 
guid='{orderGuid}' and @flag1='1' and @flag2='1'
limit 1
;
select 
case when(@flag1='1' and @flag2='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '当前订单是实物产品，不可自动进行退货办理' when(@flag2='0') then '当前订单已经进行过自动进行退货办理，无需重复操作！'  else '操作成功' end as msg