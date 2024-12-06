-- ##Title web-查询手机号更新详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询手机号更新详情
-- ##CallType[QueryData]

-- ##input seorgPhoneGuid char[36] NOTNULL;机构guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填



select 
t.guid as seorgPhoneGuid
,left(t.create_time,16) as createTime
,t.nation
,t.phonenumber
,t.create_reason as createReason
,t.evidence_imgs as evidenceImgs
from 
coz_serve_org_phone t
where guid='{seorgPhoneGuid}'