-- ##Title web-取消品类限制
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-取消品类限制
-- ##CallType[Exsql]

-- ##input permissionDetailGuid char[36] NULL;用户品类权限guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

delete from coz_app_user_permission_detail where guid='{permissionDetailGuid}';