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
set @orgName=(select name from coz_org_info where guid='{orgGuid}')
;
set @flag1=(select case when not exists(select 1 from coz_org_info where phonenumber='{phonenumber}' and name=CAST(@orgName AS char CHARACTER SET utf8) and guid<>'{orgGuid}' and del_flag='0') then '1' else '0' end)
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
where
@flag1='1'
limit 1
;
update coz_org_info t
left join
sys_weborg_user t1
on t.user_id=t1.guid
set 
t.phonenumber='{phonenumber}'
,t.update_by='{curUserId}'
,t.update_time=now()
,t1.phonenumber='{phonenumber}'
,t1.update_by='{curUserId}'
,t1.update_time=now()
where t.guid='{orgGuid}' and @flag1='1'
;
select 
case when(@flag1='1') then '1' else '0' end as okFlag
,case when(@flag1='1') then '操作成功' else concat('【',@orgName,'】已经重名','【','{phonenumber}','】不能再重名') end as msg
;