-- ##Title web-编辑用户类型信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-编辑用户类型信息
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input oldOrgName string[30] NULL;签约主体(1：机构，2：个人)，必填
-- ##input orgName string[60] NULL;签约主体(1：机构，2：个人)，必填
-- ##input oldOrgType string[30] NULL;签约主体(1：机构，2：个人)，必填
-- ##input orgType string[30] NULL;签约主体(1：机构，2：个人)，必填
-- ##input oldRoleType string[30] NULL;签约主体(1：机构，2：个人)，必填
-- ##input roleType string[30] NULL;签约主体(1：机构，2：个人)，必填
-- ##input oldRegisterCity string[30] NULL;签约主体(1：机构，2：个人)，必填
-- ##input registerCity string[30] NULL;签约主体(1：机构，2：个人)，必填

set @flag1=(select case when exists(select 1 from coz_target_object_org where object_guid='{objectGuid}' and org_name=(case when ('{orgName}'='') then ' ' else '{orgName}' end) and del_flag='0' and guid<>'{objectOrgGuid}') then '0' else '1' end)
;
update coz_target_object_org
set org_name=(case when ('{orgName}'='') then ' ' else '{orgName}' end)
,org_type='{orgType}'
,r_type='{roleType}'
,register_city='{registerCity}'
,update_by='{curUserId}'
,update_time=now()
where guid='{objectOrgGuid}' and @flag1='1'
;
update coz_target_object_org 
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{objectOrgGuid}' and ('{orgName}'='' and '{orgType}'='' and '{roleType}'='' and '{registerCity}'='') and @flag1='1'
;
update coz_serve2_bizdict
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where name='{oldOrgType}' and type='2' and not exists(select 1 from coz_target_object_org where type='2' and org_type='{oldOrgType}') and @flag1='1'
;
update coz_serve2_bizdict
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where name='{oldRegisterCity}' and type='4' and not exists(select 1 from coz_target_object_org where type='2' and register_city='{oldRegisterCity}') and @flag1='1'
;