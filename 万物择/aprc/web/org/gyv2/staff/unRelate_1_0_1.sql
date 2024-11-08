-- ##Title web-解除供应专员所关联的机构
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-解除供应专员所关联的机构
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input gyv2UserId char[36] NOTNULL;供应专员用户id，必填


delete from coz_org_gyv2_relate_staff where staff_user_id='{gyv2UserId}'
;
update coz_serve_org_relate_staff_log
set
detach_flag='1'
,detach_time=now()
,detach_by='{curUserId}'
,detach_type='3'
,update_time=now()
,update_by='{curUserId}'
where
staff_user_id='{gyv2UserId}' and detach_flag='0'
;