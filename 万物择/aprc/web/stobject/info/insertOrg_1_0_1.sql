-- ##Title web-新建用户类型信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新建用户类型信息
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input objectGuid char[36] NOTNULL;签约主体(1：机构，2：个人)，必填
-- ##input orgType string[30] NULL;签约主体(1：机构，2：个人)，必填
-- ##input orgName string[60] NULL;签约主体(1：机构，2：个人)，必填
-- ##input roleType string[30] NULL;签约主体(1：机构，2：个人)，必填
-- ##input registerCity string[30] NULL;签约主体(1：机构，2：个人)，必填

set @flag5=(select case when exists(select 1 from coz_target_object_org where org_name='{orgName}' and del_flag='0') then '0' else '1' end)
;
insert into coz_target_object_org(guid,object_guid,org_name,org_type,r_type,register_city_code,register_city,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,'{objectGuid}'
,'{orgName}'
,'{orgType}'
,'{roleType}'
,''
,'{registerCity}'
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_guidance_criterion
where ('{orgName}'<>'' or '{orgType}'<>'' or '{roleType}'<>'' or '{registerCity}'<>'') and @flag5='1'
limit 1
;
set @flag1=(select case when exists(select 1 from coz_serve2_bizdict where type='1' and name='{orgName}' and del_flag='0') then '0' else '1' end)
;
set @flag2=(select case when exists(select 1 from coz_serve2_bizdict where type='2' and name='{orgType}' and del_flag='0') then '0' else '1' end)
;
set @flag3=(select case when exists(select 1 from coz_serve2_bizdict where type='3' and name='{roleType}' and del_flag='0') then '0' else '1' end)
;
set @flag4=(select case when exists(select 1 from coz_serve2_bizdict where type='4' and name='{registerCity}' and del_flag='0') then '0' else '1' end)
;
insert into coz_serve2_bizdict(guid, type, name,create_time,create_by,update_time,update_by)
select uuid(),1,'{orgName}',current_timestamp,'{curUserId}',current_timestamp,'{curUserId}' where @flag1='1' and @flag5='1';
insert into coz_serve2_bizdict(guid, type, name,create_time,create_by,update_time,update_by)
select uuid(),2,'{orgType}',current_timestamp,'{curUserId}',current_timestamp,'{curUserId}' where @flag2='1' and @flag5='1';
insert into coz_serve2_bizdict(guid, type, name,create_time,create_by,update_time,update_by)
select uuid(),3,'{roleType}',current_timestamp,'{curUserId}',current_timestamp,'{curUserId}' where @flag3='1' and @flag5='1';
insert into coz_serve2_bizdict(guid, type, name,create_time,create_by,update_time,update_by)
select uuid(),4,'{registerCity}',current_timestamp,'{curUserId}',current_timestamp,'{curUserId}' where @flag4='1' and @flag5='1';