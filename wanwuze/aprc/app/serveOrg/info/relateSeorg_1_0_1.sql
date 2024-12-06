-- ##Title app-建立结算机构
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-建立结算机构
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input code string[6] NOTNULL;机构专属码，必填

set @seorgguid=(select guid from coz_serve_org where code='{code}' and del_flag='0')
;
set @flag1=(select case when not exists(select 1 from coz_serve_org where code='{code}' and del_flag='0') then '0' else '1' end)
;
set @flag2=(select case when not exists(select 1 from coz_serve_org_relate_staff where staff_user_id='{curUserId}' and del_flag='0') then '1' else '0' end)
;
set @seorg_stalog_st1_guid=uuid()
;
insert into coz_serve_org_relate_staff_log(guid,seorg_guid,staff_user_id,staff_type,del_flag,create_by,create_time,update_by,update_time)
select
@seorg_stalog_st1_guid as guid
,@seorgguid as user_name
,'{curUserId}' as phonenumber
,'1' as code
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1' and @flag2='1'
limit 1
;
insert into coz_serve_org_relate_staff(guid,seorg_guid,staff_user_id,staff_type,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,@seorgguid as user_name
,'{curUserId}' as phonenumber
,'1' as code
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1' and @flag2='1'
limit 1
;
insert into coz_serve_user_gain_log(guid,seorg_stalog_st1_guid,seorg_glog_guid,user_id,type,batch_no,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,@seorg_stalog_st1_guid as seorg_stalog_st1_guid
,t.seorg_glog_guid
,'{curUserId}' as user_id
,'3' as type
,'' as batch_no
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
(
select 
t4.guid as seorg_glog_guid
from
coz_serve_org t1
inner join
coz_serve_org_gain_log t4
on t1.guid=t4.seorg_guid and t4.takeback_flag='0'
left join
coz_serve_user_gain_valid t5
on t5.seorg_glog_guid=t4.guid
where t1.code='{code}' and t1.del_flag='0' and t4.del_flag='0' and t5.guid is null
) t
where @flag1='1' and @flag2='1' and not exists(select 1 from coz_serve_user_gain_log where seorg_stalog_st1_guid=@seorg_stalog_st1_guid and seorg_glog_guid=t.seorg_glog_guid and user_id='{curUserId}' and del_flag='0')
;
insert into coz_serve_user_gain_valid(guid,seorg_stalog_st1_guid,seorg_glog_guid,user_id,type,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,@seorg_stalog_st1_guid as seorg_stalog_st1_guid
,t.seorg_glog_guid
,'{curUserId}' as user_id
,'3' as type
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
(
select 
t4.guid as seorg_glog_guid
from
coz_serve_org t1
inner join
coz_serve_org_gain_log t4
on t1.guid=t4.seorg_guid and t4.takeback_flag='0'
left join
coz_serve_user_gain_valid t5
on t5.seorg_glog_guid=t4.guid
where t1.code='{code}' and t1.del_flag='0' and t4.del_flag='0' and t5.guid is null
) t
where @flag1='1' and @flag2='1' and not exists(select 1 from coz_serve_user_gain_valid where seorg_stalog_st1_guid=@seorg_stalog_st1_guid and seorg_glog_guid=t.seorg_glog_guid and user_id='{curUserId}' and del_flag='0')
;
select 
case when(@flag1='1' and @flag2='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '当前机构已删除，不可加入' when(@flag2='0') then '当前已加入机构，请先解除当前机构再加入' else '操作成功' end as msg