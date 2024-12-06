-- ##Title web-创建个人用户
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-创建个人用户
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input objName string[30] NULL;服务对象姓名，必填
-- ##input phonenumber string[11] NOTNULL;联系电话，必填
-- ##input orgType string[30] NULL;签约主体(1：机构，2：个人)，必填
-- ##input orgName string[60] NULL;签约主体(1：机构，2：个人)，必填
-- ##input roleType string[30] NULL;签约主体(1：机构，2：个人)，必填
-- ##input registerCity string[30] NULL;签约主体(1：机构，2：个人)，必填

set @objectGuid=uuid()
;
set @flag5=(select case when exists(select 1 from coz_target_object where phonenumber='{phonenumber}' and del_flag='0') then '0' else '1' end)
;
insert into coz_target_object(guid,name,phonenumber,del_flag,create_by,create_time,update_by,update_time)
select
@objectGuid
,'{objName}'
,'{phonenumber}'
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_guidance_criterion t
where 
@flag5='1'
limit 1
;
insert into coz_target_object_org(guid,object_guid,org_name,org_type,r_type,register_city_code,register_city,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,@objectGuid
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
where ('{orgName}'<>'' or '{orgType}'<>'' or '{roleType}'<>'' or '{registerCityCode}'<>'' or '{registerCity}'<>'') and @flag5='1'
limit 1
;
set @flag1=(select case when exists(select 1 from coz_serve2_bizdict where type='1' and name='{orgName}' and del_flag='0' and '{orgName}'<>'') then '0' else '1' end)
;
set @flag2=(select case when exists(select 1 from coz_serve2_bizdict where type='2' and name='{orgType}' and del_flag='0' and '{orgType}'<>'') then '0' else '1' end)
;
set @flag3=(select case when exists(select 1 from coz_serve2_bizdict where type='3' and name='{roleType}' and del_flag='0' and '{roleType}'<>'') then '0' else '1' end)
;
set @flag4=(select case when exists(select 1 from coz_serve2_bizdict where type='4' and name='{registerCity}' and del_flag='0' and '{registerCity}'<>'') then '0' else '1' end)
;
insert into coz_serve2_bizdict(guid, type, name,create_time,create_by,update_time,update_by)
select uuid(),1,'{orgName}',current_timestamp,'{curUserId}',current_timestamp,'{curUserId}' where @flag1='1' and @flag5='1';
insert into coz_serve2_bizdict(guid, type, name,create_time,create_by,update_time,update_by)
select uuid(),2,'{orgType}',current_timestamp,'{curUserId}',current_timestamp,'{curUserId}' where @flag2='1' and @flag5='1';
insert into coz_serve2_bizdict(guid, type, name,create_time,create_by,update_time,update_by)
select uuid(),3,'{roleType}',current_timestamp,'{curUserId}',current_timestamp,'{curUserId}' where @flag3='1' and @flag5='1';
insert into coz_serve2_bizdict(guid, type, name,create_time,create_by,update_time,update_by)
select uuid(),4,'{registerCity}',current_timestamp,'{curUserId}',current_timestamp,'{curUserId}' where @flag4='1' and @flag5='1';