-- ##Title app-我的-操作指导-查询工作(对接)人员是否被删除
-- ##Author 卢文彪
-- ##CreateTime 2023-09-07
-- ##Describe 当前登录用户和工作专员用户的组合在t1中不存在就表示删除了
-- ##Describe 表名： coz_server3_sys_user_dj_bind t1
-- ##CallType[QueryData]

-- ##input targetUserId char[36] NOTNULL;工作(对接)专员的用户id
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output delFlag enum[0,1] 1;对接专员是否被删除:0-否,1-是




# set @Flag1=(select case when exists(select 1 from coz_server3_sys_user_dj_bind where binded_user_id='{curUserId}' and user_guid='{targetUserId}') then '1' else '0' end)
# ;
# select
# case when (@Flag1='1') then '0' else '1' end as delFlag
# ;

select case del_flag when '0' then '0' else '1' end as delFlag
from sys_user
where user_id = '{targetUserId}';