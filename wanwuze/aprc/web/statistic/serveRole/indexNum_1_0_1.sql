-- ##Title web-查询首页统计信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询首页统计信息
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
(ifnull((select count(1) from coz_serve2_commu_task_tobject where result='1' and del_flag='0'),0)+ifnull((select count(1) from coz_serve2_serve_task_tobject_sdp where del_flag='0'),0)) as acceptServiceNum
,ifnull((select count(1) from coz_serve2_pfelang where type='2' and del_flag='0'),0) as pfelangNum
,ifnull((select count(1) from sys_user a inner join sys_user_role b on a.user_id=b.user_id inner join sys_role c on b.role_id=c.role_id where c.role_key='serveStaffRole' and a.del_flag='0' and c.del_flag='0'),0) as serveStaffRoleNum
,ifnull((select count(1) from coz_serve2_serve_task where del_flag='0'),0) as assignNum
,ifnull((select count(1) from coz_serve2_serve_task_tobject where del_flag='0'),0) as assignUserNum
,ifnull((select count(1) from coz_org_info where user_id<>'' and del_flag='0'),0) as orgNum
,ifnull((select count(1) from coz_order where pay_status='2' and del_flag='0'),0) as payOrderNum
,ifnull((select count(1) from coz_order_judge where (result='1' or result='2' or result='4') and del_flag='0'),0) as orderRefundNum
,ifnull((select count(1) from coz_order where accept_status='1' and del_flag='0'),0) as acceptNum


