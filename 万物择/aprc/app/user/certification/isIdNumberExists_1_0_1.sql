-- ##Title app-实名认证判断身份证号是否已被认证过
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-实名认证判断身份证号是否已被认证过
-- ##CallType[QueryData]

-- ##input IdNumber string[500] NOTNULL;身份证号，必填
-- ##input idType char[1] NOTNULL;证件类型（前端传1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
case when exists(select 1 from coz_app_user_certification where ID_number='{IdNumber}' and ID_type={idType} and del_flag='0') then '1' else '0' end as isExists