-- ##Title web-创建个人用户
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-创建个人用户
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input phonenumber string[11] NOTNULL;联系电话，必填
-- ##input orgType string[30] NULL;机构类型，必填
-- ##input orgName string[60] NOTNULL;机构名称，必填
-- ##input roleType string[30] NULL;角色类型，必填
-- ##input registerCity string[30] NULL;所在区域，必填
-- ##input batchUuid string[36] NOTNULL;批量处理批次，必填
-- ##input objectGuid char[36] NOTNULL;服务对象guid，必填

set @flag1=(select case when exists(select 1 from coz_target_object_org where object_guid=(select guid from coz_target_object where phonenumber='{phonenumber}'and del_flag='0' limit 1) and org_name=(case when ('{orgName}'='') then ' ' else '{orgName}' end) and del_flag='0') then '0' else '1' end)
;
insert into coz_target_object_org(guid,object_guid,org_name,org_type,r_type,register_city_code,register_city,batch_uuid,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,guid
,case when ('{orgName}'='') then ' ' else '{orgName}' end
,'{orgType}'
,'{roleType}'
,'{registerCityCode}'
,'{registerCity}'
,'{batchUuid}'
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_target_object
where phonenumber='{phonenumber}' and del_flag='0' and @flag1='1'
;

set @flag2=(select case when exists(select 1 from coz_serve2_bizdict where type='2' and name='{orgType}' and del_flag='0' and '{orgType}'<>'') then '0' else '1' end)
;
set @flag3=(select case when exists(select 1 from coz_serve2_bizdict where type='4' and name='{registerCity}' and del_flag='0' and '{registerCity}'<>'') then '0' else '1' end)
;
insert into coz_serve2_bizdict(guid, type, name,create_time,create_by,update_time,update_by)
select uuid(),2,'{orgType}',current_timestamp,'{curUserId}',current_timestamp,'{curUserId}' where @flag2='1' and @flag1='1' and '{orgType}'<>'';
insert into coz_serve2_bizdict(guid, type, name,create_time,create_by,update_time,update_by)
select uuid(),4,'{registerCity}',current_timestamp,'{curUserId}',current_timestamp,'{curUserId}' where @flag3='1' and @flag1='1' and '{registerCity}'<>'';