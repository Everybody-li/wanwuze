-- ##Title web-查询首页统计信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询首页统计信息
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
ifnull((select count(1) from coz_target_object t0 left join sys_app_user t1 on t0.user_id= t1.guid where t0.del_flag='0' and ((t1.del_flag='0' and t1.guid is not null) or t1.guid is null)),0) as userNum
,ifnull((select count(1) from coz_org_info where user_id<>'' and del_flag='0'),0) as orgNum
,ifnull((select count(1) from sys_user a inner join sys_user_role b on a.user_id=b.user_id inner join sys_role c on b.role_id=c.role_id where c.role_key='commuStaffRole' and a.del_flag='0' and c.del_flag='0'),0) as commuStaffRoleNum
,ifnull((select count(1) from sys_user a inner join sys_user_role b on a.user_id=b.user_id inner join sys_role c on b.role_id=c.role_id where c.role_key='serveStaffRole' and a.del_flag='0' and c.del_flag='0'),0) as serveStaffRoleNum
,ifnull((select count(1) from coz_demand_request where del_flag='0'),0) as demandRequestNum
,ifnull((select count(1) from coz_demand_request_supply where price_status='3' and del_flag='0'),0) as demandRequestPriceNum
,ifnull((select count(1) from coz_order where pay_status='2' and del_flag='0'),0) as payOrderNum
,ifnull((select count(1) from coz_order where supply_done_flag='1' and del_flag='0'),0) as supplyOrderNum
,ifnull((select count(1) from coz_order_judge where (result='1' or result='2' or result='4') and del_flag='0'),0) as orderRefundNum
,ifnull((select count(1) from coz_order where accept_status='1' and del_flag='0'),0) as acceptNum
,ifnull((select count(1) from sys_user a inner join sys_user_role b on a.user_id=b.user_id inner join sys_role c on b.role_id=c.role_id where c.role_key='askPriceStaffRole' and a.del_flag='0' and c.del_flag='0'),0) as askPriceStaffRoleNum