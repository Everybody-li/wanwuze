-- ##Title app-系统用户领取
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-系统用户领取
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input phonenumber string[11] NULL;服务对象手机号，非必填
-- ##input seorgStalogST1Guid char[36] NOTNULL;服务专员与服务机构关联guid，必填
-- ##input seorgGuid char[36] NOTNULL;结算机构guid，必填
-- ##input cattypeGuid char[36] NOTNULL;品类类型guid，必填
-- ##input userName string[50] NOTNULL;姓名，必填
-- ##input seorgGlogGuid char[36] NULL;服务机构与服务对象绑定guid，非必填

set @flag1=(select case when not exists(select 1 from coz_serve_org_relate_staff_log where guid='{seorgStalogST1Guid}'and del_flag='0' and detach_flag='0') then '0' else '1' end)
;
set @flag2=(select case when not exists(select 1 from coz_serve_org_category where seorg_guid='{seorgGuid}' and del_flag='0') then '0' else '1' end)
;
set @flag3=(select case when not exists(select 1 from coz_serve_user_gain_valid where seorg_glog_guid='{seorgGlogGuid}' and del_flag='0') then '1' else '0' end)
;
set @flag4=(select case when ('{seorgGlogGuid}'='') then '0' else '1' end)
;
set @seorgGlogGuid=uuid()
;
update coz_app_phonenumber
set
last_gain_ph='{phonenumber}'
,last_gain_time=now()
,update_by='{curUserId}'
,update_time=now()
where
gained_flag='1' and user_id='{curUserId}' and @flag1='1' and @flag2='1' and @flag3='1'
;
update coz_app_phonenumber
set
gain_flag='1'
,first_gain_time=now()
,first_gain_ph='{phonenumber}'
,update_by='{curUserId}'
,update_time=now()
where
gain_flag='0' and user_id='{curUserId}' and @flag1='1' and @flag2='1' and @flag3='1'
;
update coz_app_phonenumber
set
last_gained_by='{curUserId}'
,last_gained_time=now()
,update_by='{curUserId}'
,update_time=now()
where
gained_flag='1' and phonenumber='{phonenumber}' and @flag1='1' and @flag2='1' and @flag3='1'
;
update coz_app_phonenumber
set
gained_flag='1'
,first_gained_time=now()
,first_gained_by='{curUserId}'
,update_by='{curUserId}'
,update_time=now()
where
gained_flag='0' and phonenumber='{phonenumber}' and @flag1='1' and @flag2='1' and @flag3='1'
;
insert into coz_serve_org_gain_valid(guid,seorg_guid,cattype_guid,object_name,object_phonenumber,type,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{seorgGuid}' as seorg_guid
,'{cattypeGuid}' as cattype_guid
,'{userName}' as object_name
,'{phonenumber}' as object_phonenumber
,'2' as type
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1' and @flag2='1' and @flag3='1' and @flag4='0' and not exists(select 1 from coz_serve_org_gain_valid where seorg_guid='{seorgGuid}' and cattype_guid='{cattypeGuid}' and object_phonenumber='{phonenumber}' and del_flag='0')
limit 1
;
insert into coz_serve_org_gain_log(guid,seorg_guid,cattype_guid,object_name,object_phonenumber,type,del_flag,create_by,create_time,update_by,update_time)
select
@seorgGlogGuid as guid
,'{seorgGuid}' as seorg_guid
,'{cattypeGuid}' as cattype_guid
,'{userName}' as object_name
,'{phonenumber}' as object_phonenumber
,'2' as type
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1' and @flag2='1' and @flag3='1' and @flag4='0' and not exists(select 1 from coz_serve_org_gain_log where seorg_guid='{seorgGuid}' and cattype_guid='{cattypeGuid}' and object_phonenumber='{phonenumber}' and del_flag='0' and takeback_flag='0')
limit 1
;
insert into coz_serve_user_gain_valid(guid,seorg_stalog_st1_guid,seorg_glog_guid,user_id,type,del_flag,create_by,create_time,update_by,update_time)
select
*
from
(
select
UUID() as guid
,'{seorgStalogST1Guid}' as seorg_stalog_st1_guid
,case when (@flag4='0') then @seorgGlogGuid else '{seorgGlogGuid}' end as seorg_glog_guid
,'{curUserId}' as user_id
,'2' as type
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
limit 1
) t
where @flag1='1' and @flag2='1' and @flag3='1' and not exists(select 1 from coz_serve_user_gain_valid where seorg_glog_guid=t.seorg_glog_guid and del_flag='0')
;
insert into coz_serve_user_gain_log(guid,seorg_stalog_st1_guid,seorg_glog_guid,user_id,type,del_flag,create_by,create_time,update_by,update_time)
select
*
from
(
select
UUID() as guid
,'{seorgStalogST1Guid}' as seorg_stalog_st1_guid
,case when (@flag4='0') then @seorgGlogGuid else '{seorgGlogGuid}' end as seorg_glog_guid
,'{curUserId}' as user_id
,'2' as type
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
limit 1
) t
where @flag1='1' and @flag2='1' and @flag3='1' and not exists(select 1 from coz_serve_user_gain_log where seorg_glog_guid=t.seorg_glog_guid and del_flag='0')
;
select 
case when(@flag1='1' and @flag2='1'  and @flag3='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '与当前服务机构已解绑，不可领取服务对象，请先加入服务机构！' when(@flag2='0') then '当前服务机构没有授权品类，不可领取'  when(@flag3='0') then '当该手机号在服务机构的当前所有品类类型下已被领取过了，不可领取' else '操作成功' end as msg