-- ##Title app-应聘方发送一条消息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-应聘方发送一条消息
-- ##CallType[ExSql]

-- ##input friendGuid char[36] NOTNULL;好友表guid，必填
-- ##input content string[500] NOTNULL;消息内容，必填

-- {url:[http://127.0.0.1:8011/Push?ClientID={to_user_id}&Message=sendMsg|{user_id}&WaitFinish=False&Timeout=10]/url}

insert into coz_chat_msg(guid,friend_guid,from_user_id,to_user_id,content,type,read_flag,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,guid
,demand_user_id
,supply_user_id
,'{content}'
,1
,0
,0
,'-1'
,now()
,'-1'
,now()
from
coz_chat_friend
where
guid='{friendGuid}'