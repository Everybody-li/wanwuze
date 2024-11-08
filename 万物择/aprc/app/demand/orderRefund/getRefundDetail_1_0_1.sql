-- ##Title app-采购-查询退货详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-查询退货详情
-- ##CallType[QueryData]

-- ##input orderRefundGuid char[36] NOTNULL;订单退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output submitRefundAddrFlag string[1] 1;供方提交收货地址标志（0：未提交，1：已提交）
-- ##output demandSubmitProve string[1] 1;查看需方退货证明（0：未提交，1：已提交）

select
t.orderCatVirtualFlag
,case when (t.orderCatVirtualFlag='0') then '1' when exists(select 1 from coz_order_refund_supply_addr where order_refund_guid='{orderRefundGuid}' and del_flag='0') then '1' else '0' end as submitRefundAddrFlag
,case when (t.orderCatVirtualFlag='0') then '1' when exists(select 1 from coz_order_refund where guid='{orderRefundGuid}' and del_flag='0' and supply_accept_prove!=null and supply_accept_prove!='') then '1' else '0' end as demandSubmitProve
from
( 
select
t1.need_deliver_flag as orderCatVirtualFlag
from
coz_order_refund t
left join
coz_order t1
on t.order_guid=t1.guid
where t.guid='{orderRefundGuid}'
)t

