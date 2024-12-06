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
set @flag2=(select case when exists(select 1 from coz_serve2_bizdict where type='2' and name='{orgType}' and del_flag='0' and '{orgType}'<>'') then '0' else '1' end)
;
set @flag3=(select case when exists(select 1 from coz_serve2_bizdict where type='4' and name='{registerCity}' and del_flag='0' and '{registerCity}'<>'') then '0' else '1' end)
;
insert into coz_serve2_bizdict(guid, type, name,create_time,create_by,update_time,update_by)
select uuid(),2,'{orgType}',current_timestamp,'{curUserId}',current_timestamp,'{curUserId}' where @flag2='1' and @flag1='1' and '{orgType}'<>''
;
insert into coz_serve2_bizdict(guid, type, name,create_time,create_by,update_time,update_by)
select uuid(),4,'{registerCity}',current_timestamp,'{curUserId}',current_timestamp,'{curUserId}' where @flag3='1' and @flag1='1' and '{registerCity}'<>''
;