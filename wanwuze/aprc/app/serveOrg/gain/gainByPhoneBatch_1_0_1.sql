-- ##Title app-手机好友单个领取
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-手机好友单个领取
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input batchNo string[36] NOTNULL;登录用户id，必填
-- ##input name string[50] NOTNULL;服务对象姓名，必填
-- ##input phonenumber string[11] NOTNULL;服务对象手机号，必填
-- ##input seorgStalogST1Guid char[36] NOTNULL;服务专员与服务机构关联guid，必填
-- ##input seorgGuid char[36] NOTNULL;结算机构guid，必填

set @batchNo=uuid()
;
set @flag1=(select case when not exists(select 1 from coz_serve_org_relate_staff_log where staff_user_id='{curUserId}' and staff_type='1' and del_flag='0') then '0' else '1' end)
;
set @flag2=(select case when not exists(select 1 from coz_serve_org_category where seorg_guid='{seorgGuid}' and del_flag='0') then '0' else '1' end)
;
set @flag3=(select case when exists(
select 
1
from
(
select cattype_guid,'{phonenumber}' as phonenumber from coz_serve_org_category where seorg_guid='{seorgGuid}' group by cattype_guid
) a
where not exists(select 1 from coz_serve_org_gain_valid where cattype_guid=a.cattype_guid and object_phonenumber=a.phonenumber)
) then '1' else '0' end)
;
set @flag4=(select case when not exists(select 1 from coz_app_phonenumber where phonenumber='{phonenumber}' and del_flag='0') then '0' else '1' end)
;
set @flag5=(select case when exists(select 1 from coz_app_phonenumber where user_id='{curUserId}' and del_flag='0') then '1' else '0' end)
;
set @flag6=(select case when exists(select 1 from sys_app_user where guid='{curUserId}' and phonenumber='{phonenumber}') then '0' else '1' end)
;
insert into coz_app_phonenumber(guid,name,phonenumber,enter_type,gained_flag,first_gained_time,first_gained_by,last_gained_time,last_gained_by,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{name}' as name
,'{phonenumber}' as phonenumber
,'1' as enter_type
,'1' as gained_flag
,now() as first_gained_time
,'{curUserId}' as first_gained_by
,now() as last_gained_time
,'{curUserId}' as last_gained_by
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1' and @flag2='1' and @flag3='1' and @flag4='0' and @flag6='1'
limit 1
;
update coz_app_phonenumber
set
last_gain_ph='{phonenumber}'
,last_gain_time=now()
,update_by='{curUserId}'
,update_time=now()
where
gained_flag='1' and user_id='{curUserId}' and @flag1='1' and @flag2='1' and @flag3='1' and @flag5='1' and @flag6='1'
;
update coz_app_phonenumber
set
gain_flag='1'
,first_gain_time=now()
,first_gain_ph='{phonenumber}'
,update_by='{curUserId}'
,update_time=now()
where
gain_flag='0' and user_id='{curUserId}' and @flag1='1' and @flag2='1' and @flag3='1' and @flag5='1' and @flag6='1'
;
update coz_app_phonenumber
set
last_gained_by='{curUserId}'
,last_gained_time=now()
,update_by='{curUserId}'
,update_time=now()
where
gained_flag='1' and phonenumber='{phonenumber}' and @flag1='1' and @flag2='1' and @flag3='1' and @flag4='1' and @flag6='1'
;
update coz_app_phonenumber
set
gained_flag='1'
,first_gained_time=now()
,first_gained_by='{curUserId}'
,update_by='{curUserId}'
,update_time=now()
where
gained_flag='0' and phonenumber='{phonenumber}' and @flag1='1' and @flag2='1' and @flag3='1' and @flag4='1' and @flag6='1'
;
insert into coz_serve_org_gain_log(guid,seorg_guid,cattype_guid,object_name,object_phonenumber,type,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{seorgGuid}' as seorg_guid
,t.cattype_guid as cattype_guid
,'{name}' as object_name
,'{phonenumber}' as object_phonenumber
,'1' as type
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,@batchNo as update_by
,now() as update_time
from
(
select
cattype_guid
from
coz_serve_org_category t
where
seorg_guid='{seorgGuid}' and del_flag='0' and not exists(select 1 from coz_serve_org_gain_valid where cattype_guid=t.cattype_guid and object_phonenumber='{phonenumber}') 
group by cattype_guid
)t
where @flag1='1' and @flag2='1' and @flag3='1' and @flag6='1' and not exists(select 1 from coz_serve_org_gain_log where seorg_guid='{seorgGuid}' and cattype_guid=t.cattype_guid and object_phonenumber='{phonenumber}' and del_flag='0' and takeback_flag='0')
;
insert into coz_serve_org_gain_valid(guid,seorg_guid,cattype_guid,object_name,object_phonenumber,type,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{seorgGuid}' as seorg_guid
,t.cattype_guid as cattype_guid
,'{name}' as object_name
,'{phonenumber}' as object_phonenumber
,'1' as type
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
(
select
cattype_guid
from
coz_serve_org_category t
where
seorg_guid='{seorgGuid}' and del_flag='0' and not exists(select 1 from coz_serve_org_gain_valid where cattype_guid=t.cattype_guid and object_phonenumber='{phonenumber}')
group by cattype_guid
)t
where @flag1='1' and @flag2='1' and @flag3='1' and @flag6='1' and not exists(select 1 from coz_serve_org_gain_valid where seorg_guid='{seorgGuid}' and cattype_guid=t.cattype_guid and object_phonenumber='{phonenumber}' and del_flag='0')
;
insert into coz_serve_user_gain_valid(guid,seorg_stalog_st1_guid,seorg_glog_guid,user_id,type,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{seorgStalogST1Guid}' as seorg_stalog_st1_guid
,t.guid as seorg_glog_guid
,'{curUserId}' as user_id
,'1' as type
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_serve_org_gain_log t
where update_by=@batchNo and seorg_guid='{seorgGuid}' and object_phonenumber='{phonenumber}' and del_flag='0' and takeback_flag='0' and @flag1='1' and @flag2='1' and @flag3='1' and @flag6='1' and not exists(select 1 from coz_serve_user_gain_valid where seorg_glog_guid=t.guid and del_flag='0')
;
insert into coz_serve_user_gain_log(guid,seorg_stalog_st1_guid,seorg_glog_guid,user_id,type,batch_no,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{seorgStalogST1Guid}' as seorg_stalog_st1_guid
,t.guid as seorg_glog_guid
,'{curUserId}' as user_id
,'1' as type
,'{batchNo}' as batch_no
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_serve_org_gain_log t
where update_by=@batchNo and seorg_guid='{seorgGuid}' and object_phonenumber='{phonenumber}' and del_flag='0' and takeback_flag='0' and @flag1='1' and @flag2='1' and @flag3='1' and @flag6='1' and not exists(select 1 from coz_serve_user_gain_log where seorg_glog_guid=t.guid and del_flag='0')
;