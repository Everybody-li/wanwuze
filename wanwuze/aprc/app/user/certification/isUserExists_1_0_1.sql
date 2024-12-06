-- ##Title app-实名认证判断身份证号是否已被认证过
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-实名认证判断身份证号是否已被认证过
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
case when exists(select 1 from coz_app_user_certification where user_id='{curUserId}' and del_flag='0') then '1' else '0' end as isCertified