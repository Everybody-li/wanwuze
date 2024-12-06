-- ##Title web-修改各角色用户账号信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-修改各角色用户账号信息
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input userId string[50] NOTNULL;修改用户id，必填
-- ##input passwd string[100] NULL;用户密码密文，非必填
-- ##input nickName string[50] NOTNULL;用户姓名，非必填
-- ##input phonenumber string[50] NOTNULL;手机号码，非必填
-- ##input status string[50] NOTNULL;帐号状态（0：正常 1：停用），非必填

set @flag1=(select case when not exists (select 1 from sys_user where user_name='{userName}' and del_flag='0' and user_id<>'{userId}') then '1' else '0' end)
;
set @flag2=(select case when not exists (select 1 from sys_role a left join sys_user_role b on b.role_id=a.role_id left join sys_user c on c.user_id=b.user_id where a.role_key='{roleKey}' and a.del_flag='0' and  c.del_flag='0' and c.phonenumber='{phonenumber}'  and c.user_id<>'{userId}') then '1' else '0' end)
;
update sys_user
set 
dept_id='{deptId}'
,nick_name='{nickName}'
,phonenumber='{phonenumber}'
{dynamic:passwd[,password='{passwd}']/dynamic}
,status='{status}'
,update_by='{curUserId}'
,update_time=now()
where
user_id='{userId}' and @flag1='1' and @flag2='1'
;