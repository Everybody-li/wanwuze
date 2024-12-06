-- ##Title app-机构解除
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-机构解除
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input seorgGuid char[36] NOTNULL;结算机构信息guid，必填



set @flag1=(select case when exists(select 1 from coz_serve_org where guid='{seorgGuid}' and del_flag='2') then '0' else '1' end)
;
set @sorslguid=(select guid from coz_serve_org_relate_staff_log where seorg_guid='{seorgGuid}' and staff_user_id='{curUserId}' and staff_type='1' and detach_flag='0' and del_flag='0' limit 1)
;
set @maxsorslguid=(ifnull((select guid from (select guid,(select count(1) from coz_serve_order_kpi where demand_seorg_stalog_st1_guid=b.guid and del_flag='0') as kpinum from coz_serve_org_relate_staff_log b where seorg_guid='{seorgGuid}' and staff_user_id<>'{curUserId}' and staff_type='1' and detach_flag='0' and del_flag='0') a where kpinum>0 order by kpinum desc limit 1),'0'))
;
set @orgname=ifnull((select user_name from coz_serve_org where guid='{seorgGuid}'),'')
;
set @maxstaffuserid=(select staff_user_id from coz_serve_org_relate_staff_log where guid=@maxsorslguid)
;
update coz_serve_user_gain_log
set
takeback_flag='1'
,takeback_time=now()
,takeback_by='{curUserId}'
,takeback_type='3'
,update_time=now()
,update_by='{curUserId}'
where
seorg_stalog_st1_guid=@sorslguid
;
delete from coz_serve_org_relate_staff where seorg_guid='{seorgGuid}' and staff_user_id='{curUserId}' and staff_type='1'
;
update coz_serve_org_relate_staff_log
set
detach_flag='1'
,detach_time=now()
,detach_by='{curUserId}'
,update_time=now()
,update_by='{curUserId}'
where
guid=@sorslguid
;
insert into coz_serve_user_gain_log(guid,seorg_stalog_st1_guid,seorg_glog_guid,user_id,type,takeback_time,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,@maxsorslguid as seorg_stalog_st1_guid
,seorg_glog_guid
,@maxstaffuserid as user_id
,'3' as type
,null as takeback_time
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_serve_user_gain_valid t
where @flag1='1' and @maxsorslguid<>'0' and seorg_stalog_st1_guid=@sorslguid
;
update coz_serve_user_gain_valid 
set seorg_stalog_st1_guid=@maxsorslguid
,user_id=@maxstaffuserid
,type='3'
,update_time=now()
,update_by='{curUserId}'
where @flag1='1' and @maxsorslguid<>'0' and seorg_stalog_st1_guid=@sorslguid
;
delete from coz_serve_user_gain_valid where @flag1='1' and @maxsorslguid='0' and seorg_stalog_st1_guid=@sorslguid
;
select 
case when(@flag1='1' ) then '1' else '0' end as okFlag
,case when(@flag1='0') then concat('机构账号删除\n你与当前服务机构【',@orgname,'】自动解除关系\n解除关系后，你当前的权限服务对象将全部收回') else '操作成功' end as msg