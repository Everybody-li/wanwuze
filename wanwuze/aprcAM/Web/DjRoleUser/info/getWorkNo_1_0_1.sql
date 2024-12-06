-- ##Title web-对接专员操作管理-购方对接管理-查询工作编号
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 查询
-- ##Describe 表名： sys_user t1
-- ##CallType[QueryData]

-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output workNo char[6] 工作编号;工作编号

select a.ex_value as workNo from sys_user_extra a inner join sys_user b on a.user_guid=b.user_id where a.user_guid='{curUserId}' and a.ex_key='1' and b.del_flag='0' and b.status='0'