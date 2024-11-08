-- ##Title 用户-新增可领取用户
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 用户-新增可领取用户
-- ##CallType[ExSql]

-- ##input remarkUsername string[500] NOTNULL;备注姓名，必填
-- ##input userId string[36] NOTNULL;用户id，必填
-- ##input phonenumber string[20] NOTNULL;手机号，必填
-- ##input firstType string[1] NOTNULL;进入系统类型，必填
-- ##input description string[100] NOTNULL;备注描述，必填

INSERT INTO coz_guidance_free_user
(guid,first_type,type,user_id,remark_username,phonenumber,description,del_flag,create_by,create_time,update_by,update_time) 
select 
uuid() as guid
,'{firstType}'
,'1'
,'{userId}' as userId
,'{remarkUsername}' as remarkUserName
,'{phonenumber}' as phonenumber
,'{description}' as description
,'0' as del_flag
,'{userId}' as create_by
,now() as create_time
,'{userId}' as update_by
,now() as update_time
from
coz_cattype_fixed_data
where not exists(select 1 from coz_guidance_free_user where phonenumber='{phonenumber}') and 
not exists(select 1 from coz_guidance_user_record_log where phonenumber='{phonenumber}')
limit 1
;
