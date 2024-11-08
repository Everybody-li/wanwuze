-- ##Title web-新增登录手机号
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新增登录手机号
-- ##CallType[ExSql]

-- ##input orgGuid char[36] NOTNULL;机构信息guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input phonenumber string[11] NOTNULL;机构名称，必填

set @oldphonenumber=(select phonenumber from coz_org_info where guid='{orgGuid}')
;
set @userid=(select user_id from coz_org_info where guid='{orgGuid}')
;
insert into coz_org_phone_log(guid,org_guid,phonenumber,create_reason,evidence_imgs,del_flag,create_by,create_time,update_by,update_time)
select
UUID()
,'{orgGuid}'
,'{phonenumber}'
,'{createReason}'
,'{evidenceImgs}'
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_guidance_criterion t
limit 1
;
update coz_org_info
set 
phonenumber='{phonenumber}'
,update_by='{curUserId}'
,update_time=now()
where guid='{orgGuid}'
;
update sys_weborg_user
set 
phonenumber='{phonenumber}'
,update_by='{curUserId}'
,update_time=now()
where phonenumber=@oldphonenumber or guid=@userid
;
select 
'1' as okFlag
,'操作成功' as msg
;