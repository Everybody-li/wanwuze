-- ##Title app-招聘方查看聊天记录
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-招聘方查看聊天记录
-- ##CallType[QueryData]

-- ##input friendGuid char[36] NOTNULL;好友表guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input friendUserId char[36] NOTNULL;好友用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output msgGuid char[36] 消息guid;消息guid
-- ##output userId char[36] 发送方用户id;发送方用户id
-- ##output userAvatar string[20] 需方用户头像;需方用户头像
-- ##output userName string[20] 需方用户账号名称;需方用户账号名称
-- ##output fromOrtoFlag string[1] 1;发送接收标志(1：发送，2：接收)
-- ##output content string[50] 聊天内容;聊天内容
-- ##output type int[>=0] 0;消息类型（0：系统消息，1：文本消息）
-- ##output createTime datetime[yyyy-MM-dd HH:mm:ss] 0000-00-00 00:00:00;聊天时间（格式：0000-00-00 00:00:00）

update coz_chat_msg
set read_flag='1'
where friend_guid = '{friendGuid}'
  and to_user_id = '{curUserId}'
;
select *
from (select *
      from (select t1.guid          as msgGuid
                 , t1.from_user_id  as userId
                 , '招聘方头像.png' as userAvatar
                 , 1                as fromOrtoFlag
                 , t1.content
                 , t1.type
                 , t1.create_time   as createTime
                 , t1.id
            from coz_chat_friend t
                     inner join
                 coz_chat_msg t1
                 on t.guid = t1.friend_guid
                     inner join
                 sys_app_user t2
                 on t.supply_user_id = t2.guid
            where t.guid = '{friendGuid}'
              and t1.from_user_id = '{curUserId}'
              and t1.type <> '0'
              and t.del_flag = '0'
            union all
            select t1.guid          as msgGuid
                 , t1.from_user_id  as userId
                 , '应聘方头像.png' as userAvatar
                 , 2                as fromOrtoFlag
                 , t1.content
                 , t1.type
                 , t1.create_time   as createTime
                 , t1.id
            from coz_chat_friend t
                     inner join
                 coz_chat_msg t1
                 on t.guid = t1.friend_guid
                     inner join
                 sys_app_user t2
                 on t.demand_user_id = t2.guid
            where t.guid = '{friendGuid}'
              and t1.from_user_id = '{friendUserId}'
              and t.del_flag = '0') t
      order by t.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size}
     ) res
order by res.id;

