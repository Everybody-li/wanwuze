-- ##Title web-查询服务机构最近收回授权的品类类型
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务机构最近收回授权的品类类型
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填

select
t.user_id as userId
,t.content
,t.type as msgType
from
coz_app_user_notice t
where t.user_id='{curUserId}' and t.del_flag='0' and t.read_flag='1'
order by t.type,t.id desc