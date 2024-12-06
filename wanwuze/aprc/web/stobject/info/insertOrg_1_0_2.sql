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

set @flag1=(select case when exists(select 1 from coz_target_object_org where object_guid='{objectGuid}' and org_name=(case when ('{orgName}'='') then ' ' else '{orgName}' end) and del_flag='0') then '0' else '1' end)
;
insert into coz_target_object_org(guid,object_guid,org_name,org_type,r_type,register_city_code,register_city,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,'{objectGuid}'
,case when ('{orgName}'='') then ' ' else '{orgName}' end
,'{orgType}'
,'{roleType}'
,'{registerCityCode}'
,'{registerCity}'
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_guidance_criterion
where  @flag1='1'
limit 1
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
select 
case when(@flag1='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '手机号已存在，请更换~' else '操作成功' end as msg
;