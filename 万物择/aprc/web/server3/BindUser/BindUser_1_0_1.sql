-- ##Title web-运营专员操作管理-运营用户管理-服务专员用户管理-服务主管关联
-- ##Author 卢文彪
-- ##CreateTime 2023-12-19
-- ##Describe 新增关联关系
-- ##Describe 表名: coz_server3_sys_user_bind,coz_server3_sys_user_bind_log
-- ##CallType[ExSql]

-- ##input userGuid char[36] NOTNULL;服务专员guid
-- ##input targetUserId char[36] NOTNULL;被关联用户(服务主管)guid
-- ##input curUserId string[36] NOTNULL;登录用户id

set @bindFlag = 0;

# 已存在则不重复绑定
select count(*)
into @bindFlag
from coz_server3_sys_user_bind
where bind_suser_guid = '{userGuid}'
  and binded_suser_guid = '{targetUserId}';

set @bindGuid = uuid();
insert into coz_server3_sys_user_bind (guid, bind_suser_guid, binded_suser_guid, create_by, create_time)
select @bindGuid, '{userGuid}', '{targetUserId}', '{userGuid}', current_timestamp()
where @bindFlag = 0;


insert into coz_server3_sys_user_bind_log (guid, bind_guid, bind_suser_guid, binded_suser_guid, create_by, create_time)
select uuid(), @bindGuid, '{userGuid}', '{targetUserId}', '{userGuid}', current_timestamp()
where @bindFlag = 0;
