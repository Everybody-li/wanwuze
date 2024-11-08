-- ##Title web-查询首页统计信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询首页统计信息
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input userId string[36] NOTNULL;目标用户id(交易专员用户id)，必填

select 
ifnull((select count(1) from (select count(1) from coz_category_supplier t3 inner join coz_category_info t2 on t3.category_guid=t2.guid where t2.del_flag='0' and t3.del_flag='0' and t2.cattype_guid in (select t1.cattype_guid from coz_server2_sys_user_cattype t1 where t1.user_id='{userId}' and t1.del_flag='0') group by t3.user_id)t),0) as orgNum
,ifnull((select count(1) from coz_demand_request where del_flag='0' and cattype_guid in (select t1.cattype_guid from coz_server2_sys_user_cattype t1 where t1.user_id='{userId}' and t1.del_flag='0')),0) as demandRequestNum
,ifnull((select count(1) from coz_demand_request_supply t5 inner join coz_demand_request t4 on t4.guid=t5.request_guid where t5.price_status='3' and t4.del_flag='0' and t5.del_flag='0' and t4.cattype_guid in (select t1.cattype_guid from coz_server2_sys_user_cattype t1 where t1.user_id='{userId}' and t1.del_flag='0')),0) as demandRequestPriceNum
,ifnull((select count(1) from coz_order t6 inner join coz_demand_request t4 on t4.guid=t6.request_guid where t6.pay_status='2' and t4.del_flag='0' and t6.del_flag='0' and t4.cattype_guid in (select t1.cattype_guid from coz_server2_sys_user_cattype t1 where t1.user_id='{userId}' and t1.del_flag='0')),0) as payOrderNum
,ifnull((select count(1) from coz_order t6 inner join coz_demand_request t4 on t4.guid=t6.request_guid where t6.supply_done_flag='1' and t4.del_flag='0' and t6.del_flag='0' and t4.cattype_guid in (select t1.cattype_guid from coz_server2_sys_user_cattype t1 where t1.user_id='{userId}' and t1.del_flag='0')),0) as supplyOrderNum
,ifnull((select count(1) from coz_order_judge t7 inner join coz_order t6 on t6.guid=t7.order_guid inner join coz_demand_request t4 on t4.guid=t6.request_guid  where (t7.result='1' or t7.result='2' or t7.result='4') and t4.del_flag='0' and t6.del_flag='0' and t7.del_flag='0' and t4.cattype_guid in (select t1.cattype_guid from coz_server2_sys_user_cattype t1 where t1.user_id='{userId}' and t1.del_flag='0')),0) as orderRefundNum
,ifnull((select count(1) from coz_order t6 inner join coz_demand_request t4 on t4.guid=t6.request_guid where t6.accept_status='1' and t4.del_flag='0' and t6.del_flag='0' and t4.cattype_guid in (select t1.cattype_guid from coz_server2_sys_user_cattype t1 where t1.user_id='{userId}' and t1.del_flag='0')),0) as acceptNum