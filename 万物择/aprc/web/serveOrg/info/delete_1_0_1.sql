-- ##Title web-删除机构名称信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除机构名称信息
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input seorgGuid string[36] NOTNULL;机构专属码，必填

set @flag1=(select case when exists(select 1 from coz_serve_org where guid='{seorgGuid}' and del_flag='0') then '1' else '0' end)
;
set @biz_no=uuid()
;
set @seorg_name=(select user_name from coz_serve_org where guid='{seorgGuid}')
;
update coz_serve_org 
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{seorgGuid}' and @flag1='1'
;
insert into coz_app_user_notice(guid,type,biz_no,user_id,title,content,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'1' as type
,@biz_no as biz_no
,t2.staff_user_id as user_id
,'服务模块' as title
,concat('机构账号删除。你与当前服务机构【',@seorg_name,'】自动解除关系。解除关系后，你当前的权限服务对象将全部收回') as noticeContent
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_serve_org_relate_staff t2
where t2.seorg_guid='{seorgGuid}' and staff_type='1' and @flag1='1'
;
delete from coz_serve_org_relate_staff where seorg_guid='{seorgGuid}' and @flag1='1'
;
update coz_serve_org_relate_staff_log
set
detach_flag='1'
,detach_time=now()
,detach_by='{curUserId}'
,detach_type='3'
,update_by='{curUserId}'
,update_time=now()
where seorg_guid='{seorgGuid}' and @flag1='1'
;
delete from coz_serve_org_category where seorg_guid='{seorgGuid}' and @flag1='1'
;
update coz_serve_org_category_log
set
grant_status='2'
,op_type='2'
,update_by='{curUserId}'
,update_time=now()
where seorg_guid='{seorgGuid}' and @flag1='1'
;
delete from coz_serve_org_gain_valid where seorg_guid='{seorgGuid}' and @flag1='1'
;
update coz_serve_org_gain_log
set
takeback_flag='1'
,takeback_time=now()
,takeback_by='{curUserId}'
,takeback_type='2'
,takeback_by='{curUserId}'
,update_by='{curUserId}'
,update_time=now()
where seorg_guid='{seorgGuid}' and @flag1='1'
;
delete from coz_serve_user_gain_valid t where exists(select 1 from coz_serve_org_gain_log where guid=t.seorg_glog_guid and seorg_guid='{seorgGuid}') and @flag1='1'
;
update coz_serve_user_gain_log t
set
takeback_flag='1'
,takeback_time=now()
,takeback_by='{curUserId}'
,takeback_type='2'
,takeback_by='{curUserId}'
,update_by='{curUserId}'
,update_time=now()
where exists(select 1 from coz_serve_org_gain_log where guid=t.seorg_glog_guid and seorg_guid='{seorgGuid}') and @flag1='1'
;
update coz_serve_org_relate_suorg t
set
detach_flag='1'
,detach_time=now()
,update_by='{curUserId}'
,update_time=now()
where exists(select 1 from coz_serve_org_relate_staff_log where guid=t.seorg_stalog_guid and seorg_guid='{seorgGuid}') and @flag1='1'
;

select user_id as seorgST1UserId,content,type as msgType from coz_app_user_notice where biz_no=@biz_no
;