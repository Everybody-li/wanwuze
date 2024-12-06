-- ##Title 机构用户-新增用户
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 机构用户-新增用户
-- ##CallType[ExSql]

-- ##input userName string[50] NOTNULL;修改用户id，必填
-- ##input phonenumber string[11] NOTNULL;手机号码，必填


insert into sys_weborg_user(guid,user_name,nick_name,phonenumber,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,'{userName}'
,'{userName}'
,'{phonenumber}'
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_guidance_criterion
where not exists(select 1 from sys_weborg_user where (user_name='{userName}' or phonenumber='{phonenumber}') and del_flag='0')
limit 1