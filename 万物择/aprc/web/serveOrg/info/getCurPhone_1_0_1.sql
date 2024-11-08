-- ##Title web-查询机构名称信息列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询机构名称信息列表
-- ##CallType[QueryData]

-- ##input seorgGuid char[36] NOTNULL;机构名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填



select 
t.guid as seorgGuid
,t.nation
,t.phonenumber
,left(t.create_time,16) as createTime
from 
coz_serve_org_phone t
where seorg_guid='{seorgGuid}'
order by id desc
limit 1