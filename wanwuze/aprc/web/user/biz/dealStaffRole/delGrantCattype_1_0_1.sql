-- ##Title web-交易专员-保存选中的品类类型列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-交易专员-保存选中的品类类型列表
-- ##CallType[ExSql]

-- ##input cattypeGuid char[36] NOTNULL;品类类型guid，必填
-- ##input roleKey string[50] NOTNULL;目标用户角色类型，必填
-- ##input userId string[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_server2_sys_user_cattype
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where cattype_guid='{cattypeGuid}' and del_flag='0' and user_id='{userId}' and role_key='{roleKey}'