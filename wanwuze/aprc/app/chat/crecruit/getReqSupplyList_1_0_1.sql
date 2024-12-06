-- ##Title app-招聘-查询某个招聘信息的投递记录
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-招聘-查询某个招聘信息的投递记录
-- ##CallType[QueryData]

-- ##input recruitGuid char[36] NOTNULL;招聘信息guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

update coz_chat_demand_request_supply
set recruit_read_flag='1'
  , update_by='{curUserId}'
  , update_time=now()
where recruit_guid = '{recruitGuid}'
  and recruit_read_flag = '2'
;
select t1.guid                  as deRequestGuid
     , t1.user_id               as userId
     , t1.user_name             as userName
     , left(t3.create_time, 16) as sendResmTime
     , t3.status                as applyFriStatus
     , left(t3.react_time, 16)  as applyReactTime
     , t3.guid                  as applyGuid
from coz_chat_demand_request t1
         left join
     coz_chat_demand_request_supply t2
     on t1.guid = t2.de_request_guid
         inner join
     coz_chat_friend_apply t3
     on t2.guid = t3.request_supply_guid
where t2.recruit_guid = '{recruitGuid}'
  and t1.del_flag = '0'
  and t2.del_flag = '0'
  and (t3.del_flag = '0' and t3.target_user_id = '{curUserId}')
  and t2.recommend_type = '1'
order by t3.create_time desc
Limit {compute:[({page}-1)*{size}]/compute},{size};
