-- ##Title app-查询用户是否有结算机构
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-查询用户是否有结算机构
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
case when (exists(select 1 from coz_serve_org_relate_staff where staff_user_id='{curUserId}'and staff_type='1' and del_flag='0')) then 1 else 0 end as hasSeorg
