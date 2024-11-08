-- ##Title web-运营专员操作管理-运营用户管理-服务专员用户管理-解除与服务主管关联
-- ##Author 卢文彪
-- ##CreateTime 2023-12-19
-- ##Describe 解除关联关系
-- ##Describe 表名: coz_server3_sys_user_bind,coz_server3_sys_user_bind_log
-- ##CallType[ExSql]

-- ##input bindGuid char[36] NOTNULL;服务专员与服务主管关联guid
-- ##input curUserId string[36] NOTNULL;登录用户id

delete
from coz_server3_sys_user_bind
where guid = '{bindGuid}';

update coz_server3_sys_user_bind_log
set unbind_type = 3,
    unbind_time = now()
where bind_guid = '{bindGuid}';
