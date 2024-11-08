-- ##Title web-删除机构名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除机构名称
-- ##CallType[ExSql]

-- ##input orgGuid char[36] NOTNULL;机构名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_org_info
set 
del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{orgGuid}'and user_id=''
;
