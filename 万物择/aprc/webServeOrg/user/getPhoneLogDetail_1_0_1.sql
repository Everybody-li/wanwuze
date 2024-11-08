-- ##Title web-查询手机号更新详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询手机号更新详情
-- ##CallType[QueryData]

-- ##input phoneLogGuid char[36] NOTNULL;机构guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t1.user_name as orgName
,t.nation
,t.phonenumber
,t.create_reason as createReason
,t.evidence_imgs as evidenceImgs
from 
coz_serve_org_phone t
left join
coz_serve_org t1
on t.seorg_guid=t1.guid
where t.guid='{phoneLogGuid}'