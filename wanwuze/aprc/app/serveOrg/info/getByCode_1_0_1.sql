-- ##Title web-查询手机号更新详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询手机号更新详情
-- ##CallType[QueryData]

-- ##input code string[6] NOTNULL;机构名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填



select 
t.guid as seorgGuid
,t.code
,t.phonenumber
,user_name as userName
from 
coz_serve_org t
where code='{code}' and status='0'