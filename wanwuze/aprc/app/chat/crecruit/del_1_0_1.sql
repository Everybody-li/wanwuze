-- ##Title app-删除招聘信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-删除招聘信息
-- ##CallType[ExSql]

-- ##input recruitGuid char[36] NOTNULL;招聘信息guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_chat_recruit_detail
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where recruit_guid='{recruitGuid}'
;
update coz_chat_recruit
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{recruitGuid}'
;
