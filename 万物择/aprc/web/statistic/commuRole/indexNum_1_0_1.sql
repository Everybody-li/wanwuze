-- ##Title web-查询首页统计信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询首页统计信息
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
ifnull((select count(1) from coz_target_object t1 left join sys_app_user t0 on t1.phonenumber=t0.phonenumber where t1.del_flag='0' and (t0.guid is null or (t0.guid is not null and t0.status=0))),0) as canAssignUserNum
,ifnull((select count(1) from coz_cattype_sd_path where name<>'' and del_flag='0'),0) as sdPNameNum
,ifnull((select count(1) from coz_serve2_pfelang where type='1' and del_flag='0'),0) as pfelangNum
,ifnull((select count(1) from sys_user a inner join sys_user_role b on a.user_id=b.user_id inner join sys_role c on b.role_id=c.role_id where c.role_key='commuStaffRole' and a.del_flag='0' and c.del_flag='0'),0) as commuStaffRoleNum
,ifnull((select count(1) from sys_user a inner join sys_user_role b on a.user_id=b.user_id inner join sys_role c on b.role_id=c.role_id where c.role_key='serveStaffRole' and a.del_flag='0' and c.del_flag='0'),0) as serveStaffRoleNum
,ifnull((select count(1) from coz_serve2_commu_task where del_flag='0'),0) as assignNum
,ifnull((select count(1) from coz_serve2_commu_task_tobject where del_flag='0'),0) as assignUserNum
,ifnull((select count(1) from coz_serve2_commu_task_tobject where result='1' and del_flag='0'),0) as acceptServiceNum