-- ##Title app-删除好友
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-删除好友
-- ##CallType[ExSql]

-- ##input userId char[36] NOTNULL;用户id，必填
-- ##input deleteUserId char[36] NOTNULL;被删除用户id，必填



update coz_chat_friend
set del_flag='2'
,update_by='{userId}'
,update_time=now()
where (supply_user_id='{userId}' and demand_user_id='{deleteUserId}') or (supply_user_id='{deleteUserId}' and demand_user_id='{userId}')
;

update coz_chat_msg
set del_flag='2'
,update_by='{userId}'
,update_time=now()
where (from_user_id='{userId}' and to_user_id='{deleteUserId}') or (from_user_id='{deleteUserId}' and to_user_id='{userId}')
;

