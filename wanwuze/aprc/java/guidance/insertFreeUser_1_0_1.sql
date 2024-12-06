-- ##Title 用户-新增可领取库服务
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 引导-新增可领取用户
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;用户id，必填
-- ##input userName string[500] NOTNULL;备注姓名，必填
-- ##input phonenumber string[20] NOTNULL;手机号，必填


INSERT INTO coz_guidance_free_user
(guid,first_type,type,user_id,remark_username,phonenumber,description,del_flag,create_by,create_time,update_by,update_time) 
select 
uuid() as guid
,'3'
,'1'
,'{curUserId}' as userId
,'{userName}' as remarkUserName
,'{phonenumber}' as phonenumber
,'app用户自主注册' as description
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_cattype_fixed_data
where not exists(select 1 from coz_guidance_free_user where phonenumber='{phonenumber}')
limit 1
;
