-- ##Title app-判断用户是否可以注销账号
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-判断用户是否可以注销账号
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填


set @flag1=(select case when not exists(select 1 from sys_app_user where guid='{curUserId}' and del_flag='0' and status='0') then '0' else '1' end)
;
set @flag2=(select case when exists(select 1 from coz_order a left join coz_order_fee_settle b on a.guid=b.order_guid left join coz_order_judge c on a.guid=c.order_guid where ((a.demand_user_id='{curUserId}' and b.guid is null and a.accept_way='0' and c.guid is null) or (b.guid is not null and a.accept_status='1'and a.demand_user_id='{curUserId}' and b.pay_type='0')) and a.del_flag='0') then '0' else '1' end)
;
set @flag3=(select case when exists(select 1 from coz_order a inner join coz_order_judge b on a.guid=b.order_guid where a.demand_user_id='{curUserId}' and b.result='0' and a.del_flag='0' and b.del_flag='0') then '0' else '1' end)
;
set @flag4=(select case when exists(select 1 from coz_order a inner join coz_order_judge b on a.guid=b.order_guid inner join coz_order_judge_fee c on b.guid=c.judge_guid where a.demand_user_id='{curUserId}' and c.confirm_pay_flag='1' and a.del_flag='0' and b.del_flag='0' and c.del_flag='0') then '0' else '1' end)
;
select 
case when(@flag1='1' and @flag2='1' and @flag3='1' and @flag4='1') then '1' else '0' end as canFlag
,case when(@flag1='0') then '用户已停用或已注销，无需再次操作' when(@flag2='0' or @flag3='0' or @flag4='0') then '成果交接中有订单未完成交接或者费用结算管理中有订单的费用未完结。暂时不能注销账号' else '你的成果交接无订单需要处理或者你的费用结算管理中费用已经完结。可以注销。注销后，若需要我们服务，请重新注册。' end as msg
