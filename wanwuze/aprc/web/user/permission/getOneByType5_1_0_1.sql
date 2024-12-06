-- ##Title web-查看用户操作权限（品类供应操作权限）
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看用户操作权限（品类供应操作权限）
-- ##CallType[QueryData]

-- ##input userId char[36] NOTNULL;用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output userId char[36] 用户id;用户id
-- ##output remark string[100] 理由;理由
-- ##output categoryGuid string[50] 品类guid;品类guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output status int[>=0] 1;权限状态（0：禁用，1：启用）
-- ##output createTime string[19] 禁用起始时间;禁用起始时间


select
t2.user_id as userId
,t2.guid as permissonDetailGuid
,t3.guid as categoryGuid
,t3.name as categoryName
,t3.cattype_name as cattypeName
,if(t2.type=5,'1','0') as status
,t2.update_time as createTime
from
sys_app_user t
right join
coz_app_user_permission_detail t2
on t2.user_id=t.guid and type=5
left join
coz_category_info t3
on t2.biz_guid=t3.guid
where 
t.guid='{userId}' and t.del_flag=0