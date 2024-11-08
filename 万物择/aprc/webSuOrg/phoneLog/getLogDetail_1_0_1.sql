-- ##Title web-查询手机号更新详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询手机号更新详情
-- ##CallType[QueryData]

-- ##input phoneLogGuid char[36] NOTNULL;机构名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填



select 
t.guid as phoneLogGuid
,t.nation
,t.phonenumber
,left(t.create_time,16) as createTime
,t.create_reason as createReason
,t.evidence_imgs as evidenceImgs
from 
coz_org_phone_log t
where guid='{phoneLogGuid}'