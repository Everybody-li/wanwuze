-- ##Title 新增服务专员H5报名
-- ##Author lith
-- ##CreateTime 2026-02-28
-- ##Describe app-我要反馈（新增反馈）
-- ##CallType[ExSql]

-- ##input _name string[100] NOTNULL;服务人员姓名
-- ##input _phonenumber char[11] NOTNULL;服务人员手机号
-- ##input _nation string[5] NOTNULL;国家地区区号
-- ##input _sys_city_code string[30] NOTNULL;所在区域code
-- ##input _sys_city_code_guid char[36] NOTNULL;所在区域guid
-- ##input serve_directory_user_guid char[36] NOTNULL;服务主用户管guid

insert into coz_serve3_signin_record (guid, name, phonenumber, nation, user_id, sys_city_code,
                                      serve_directory_user_guid, del_flag, create_by, create_time, update_by,
                                      update_time)
select
    uuid(), '{name}', '{phonenumber}', '{nation}', '', '{sys_city_code}', '{serve_directory_user_guid}', '0',
        '{curUserId}', now(), '{curUserId}', now()
from coz_serve3_signin_record
where not exists(select 1 from coz_serve3_signin_record where phonenumber = '{phonenumber}')
;