-- ##Title app-采购方设置好友备注
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购方设置好友备注
-- ##CallType[ExSql]

-- ##input remark string[20] NOTNULL;备注名称，必填
-- ##input userId char[36] NOTNULL;用户id，必填
-- ##input supplyUserId char[36] NOTNULL;好友id（供方用户id），必填


update coz_chat_friend
set demand_friend_remark='{remark}'
,update_time=now()
where demand_user_id='{userId}' and supply_user_id='{supplyUserId}'
;
