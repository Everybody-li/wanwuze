-- ##Title app-供应-查询退货签收详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-查询退货签收详情
-- ##CallType[QueryData]

-- ##input orderRefundGuid char[36] NULL;订单退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output submitRefundAddrFlag string[1] 1;供方提交收货地址标志（0：未提交，1：已提交）
-- ##output demandSubmitProve string[1] 1;查看需方退货证明（0：置灰，1：高亮）
-- ##output supplyAcceptOKFlag string[1] 1;供方验收通过标志（0：置灰，1：高亮）
-- ##output supplyAcceptNotOKFlag string[1] 1;供方验不收通过标志（0：置灰，1：高亮）

set @Flag1=(select case when exists(select 1 from coz_order_refund_supply_addr  where order_refund_guid='{orderRefundGuid}' and del_flag='0') then '1' else '0' end  from coz_order_refund where guid='{orderRefundGuid}')
;
set @Flag2=(select case when(prove_logistic_img!='' and prove_supply_sign_imgs!='') then '1' else '0' end  from coz_order_refund where guid='{orderRefundGuid}')
;
set @Flag3=(select case when(supply_accept_prove!='') then '1' else '0' end  from coz_order_refund where guid='{orderRefundGuid}')
;
select 
case when (@Flag1='1') then '1' else '0' end as submitRefundAddrFlag
,case when (@Flag2='1') then '1' else '0' end as demandSubmitProve
,case when (@Flag1='1' and @Flag2='1' and @Flag3='1') then '1' else '0' end as supplyAcceptOKFlag
,case when (@Flag1='1' and @Flag2='1' and @Flag3='1') then '1' else '0' end supplyAcceptNotOKFlag
