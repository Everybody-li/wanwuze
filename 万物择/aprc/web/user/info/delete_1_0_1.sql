
-- ##Title web-删除各角色账号信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除各角色账号信息
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input userId string[36] NOTNULL;要删除的用户id，必填

set @flag1 = (select case
                         when exists(select 1
                                     from sys_user a
                                              inner join sys_user_role b on a.user_id = b.user_id
                                              inner join sys_role c on b.role_id = c.role_id
                                     where a.user_id = '{userId}'
                                       and c.role_key = 'duijieRole') then '1'
                         else '0' end)
;
set @flag2 = (select case
                         when exists(select 1
                                     from sys_user a
                                              inner join sys_user_role b on a.user_id = b.user_id
                                              inner join sys_role c on b.role_id = c.role_id
                                     where a.user_id = '{userId}'
                                       and c.role_key = 'duijieDirectorRole') then '1'
                         else '0' end)
;

delete from coz_server3_sys_user_bind where binded_suser_guid='{userId}' and (@Flag1='1' or @Flag2='1')
;
update coz_server3_sys_user_bind_log
set 
unbind_type=case when (@Flag1='1') then '1' when (@Flag2='1') then '2' else '0' end
,unbind_time=now()
where 
binded_suser_guid = '{userId}'and (@Flag1='1' or @Flag2='1')
;
delete from coz_server3_sys_user_dj_bind where user_guid='{userId}' and (@Flag1='1' or @Flag2='1')
;
insert into coz_server3_sys_user_dj_bind_log
( guid
, bind_guid
, user_guid
, user_type
, bind_type
, binded_user_id
, create_time
, create_by
, del_flag)
select uuid()
     , guid
     , t.user_guid
     , '1'
     , '2'
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , '0'
from coz_server3_sys_user_dj_bind t
where user_guid = '{userId}'
  and @Flag1 = '1'
limit 1
;
update sys_user
set del_flag='2'
  , update_by='{curUserId}'
  , update_time=now()
where user_id = '{userId}'
;
delete
from sys_user_role
where user_id = '{userId}'
;