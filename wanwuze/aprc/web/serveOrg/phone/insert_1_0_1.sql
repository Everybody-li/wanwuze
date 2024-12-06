-- ##Title web-新增登录手机号
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新增登录手机号
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input seorgGuid string[36] NOTNULL;机构名称，必填
-- ##input phonenumber string[11] NOTNULL;机构名称，必填
-- ##input createReason string[200] NULL;机构名称，必填
-- ##input evidenceImgs string[600] NULL;机构名称，必填

insert into coz_serve_org_phone(guid,seorg_guid,phonenumber,create_reason,evidence_imgs,del_flag,create_by,create_time)
select
UUID() as guid
,'{seorgGuid}' as seorgGuid
,'{phonenumber}' as phonenumber
,'{createReason}' as createReason
,'{evidenceImgs}' as evidenceImgs
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
from
coz_guidance_criterion t
limit 1
;
update coz_serve_org
set 
phonenumber='{phonenumber}'
,update_by='{curUserId}'
,update_time=now()
where guid='{seorgGuid}'
;
select 
case when('1'='1') then '1' else '0' end as okFlag
,case when('1'='1') then '操作成功' else '系统异常，请重试' end as msg