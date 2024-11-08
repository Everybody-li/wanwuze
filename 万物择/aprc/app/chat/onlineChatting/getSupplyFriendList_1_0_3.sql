-- ##Title app-招聘方查看好友列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-招聘方查看好友列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output msgGuid char[36] 消息guid;消息guid
-- ##output demandUserAvatar string[20] 需方用户头像;需方用户头像
-- ##output demandUserName string[20] 需方用户账号名称;需方用户账号名称
-- ##output content string[50] 最近一条聊天内容;最近一条聊天内容
-- ##output applyDate datetime[yyyy-MM-dd HH:mm:ss] 0000-00-00 00:00:00;聊天时间（格式：0000-00-00 00:00:00，展示格式app端自行转换下）


select t.*
     , t1.content
     , left(t1.create_time, 19) as createTime
from (select t.guid                 as friendGuid
           , '应聘方头像.png'         as demandUserAvatar
           , t.supply_friend_remark as demandUserName
           , t.demand_user_id       as demandUserId
           , (select guid
              from (select guid, id
                    from coz_chat_msg
                    where friend_guid = t.guid
                      and (type = '0' and from_user_id = '{curUserId}')
                    union all
                    select guid, id
                    from coz_chat_msg
                    where friend_guid = t.guid
                      and type <> '0') a
              order by a.id desc
              limit 1)              as msgGuid
           , case
                 when (exists(select 1
                              from coz_chat_msg
                              where friend_guid = t.guid
                                and to_user_id = '{curUserId}'
                                and read_flag = '0')) then '0'
                 else '1' end       as contentReadFlag
           , t.id
      from coz_chat_friend t
               left join
           sys_app_user t1
           on t.demand_user_id = t1.guid
      where t.supply_user_id = '{curUserId}'
        and t.del_flag = 0) t
         left join
     coz_chat_msg t1
     on t.msgGuid = t1.guid
order by t1.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};