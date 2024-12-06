-- ##Title 服务共用方法-工具栏-对接专员-查询需方当前绑定的对接专员
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 查询需方未删除的已绑定的对接专员
-- ##Describe 表名：oz_server3_sys_user_dj_bind t1,sys_user t2
-- ##CallType[QueryData]

-- ##input curUserId char[36] NOTNULL;需方用户id


select a.user_guid from coz_server3_sys_user_dj_bind a inner join sys_user b on a.user_guid=b.user_id where a.binded_user_id='{curUserId}' and b.del_flag='0' and b.status='0' limit 1