-- ##Title web-查看用户操作权限（根据操作权限类型）
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看用户操作权限（根据操作权限类型）
-- ##CallType[QueryData]

-- ##input userId char[36] NOTNULL;用户id，必填
-- ##input type int[>=0] NOTNULL;权限类型(1：账号操作权限，2：采购操作权限，3：供应操作权限)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output userId char[36] 用户id;用户id
-- ##output status int[>=0] 1;权限状态（0：禁用，1：启用）
-- ##output createTime string[19] 禁用起始时间;禁用起始时间


select
t.guid as userId
,ifnull(t1.status,'0') as status
,t1.update_time as createTime
from
sys_app_user t
left join
coz_app_user_permission t1
on t.guid=t1.user_id and type={type}
where 
t.guid='{userId}' and t.del_flag=0
;
