-- ##Title web-给服务机构批量解除授权品类
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-给服务机构批量解除授权品类
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input seorgGuid string[36] NOTNULL;机构专属码，必填
-- ##input categoryGuid string[1000] NULL;品类名称guid(可能多个)，必填


delete from coz_serve_org_category where seorg_guid='{seorgGuid}' and category_guid in({categoryGuid})
;
update coz_serve_org_category_log
set
grant_status='2'
,op_type='4'
,update_by='{curUserId}'
,update_time=now()
where seorg_guid='{seorgGuid}' and category_guid in({categoryGuid})
;

set @flag1=(select case when exists(select 1 from coz_serve_org_gain_valid t where seorg_guid='{seorgGuid}' and cattype_guid in (select cattype_guid from coz_category_info where guid in ({categoryGuid}) and not exists(select 1 from coz_serve_org_category where seorg_guid='{seorgGuid}' and cattype_guid=t.cattype_guid and del_flag='0')) and del_flag='0') then '1' else '0' end)
;
set @biz_no=uuid()
;
set @seorg_name=(select user_name from coz_serve_org where guid='{seorgGuid}')
;
insert into coz_app_user_notice(guid,type,biz_no,user_id,title,content,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'2' as type
,@biz_no as biz_no
,t1.seorgST1UserId as user_id
,'服务模块' as title
,concat('【',@seorg_name,'】品类收授权收回。你当前的权限服务对象对象标签是【',t1.cattypeName,'】将全部收回') as noticeContent
,'0' as del_flag
,t1.seorgGuid as create_by
,now() as create_time
,t1.cattypeGuid as update_by
,now() as update_time
from
(
select distinct ugv.user_id as seorgST1UserId,cfd.name as cattypeName,sogl.cattype_guid as cattypeGuid,sogl.seorg_guid as seorgGuid
from coz_serve_org_gain_log sogl
         inner join (select count(distinct grant_status) co, cattype_guid, grant_status, seorg_guid, guid, concat(cattype_guid)
    from coz_serve_org_category_log
    where cattype_ungrant = '0' and seorg_guid ='{seorgGuid}'
    group by seorg_guid, cattype_guid having co = 1) t on sogl.cattype_guid = t.cattype_guid and sogl.seorg_guid = t.seorg_guid and sogl.takeback_flag = '0'
         inner join coz_cattype_fixed_data cfd on sogl.cattype_guid = cfd.guid
         inner join coz_serve_user_gain_valid ugv on sogl.guid = ugv.seorg_glog_guid
where t.grant_status = '2'
group by ugv.user_id, sogl.cattype_guid
) t1
where
@flag1='1'
;

delete from coz_serve_org_gain_valid t where seorg_guid='{seorgGuid}' and cattype_guid in (select cattype_guid from coz_category_info where guid in ({categoryGuid}) and not exists(select 1 from coz_serve_org_category where seorg_guid='{seorgGuid}' and cattype_guid=t.cattype_guid and del_flag='0')) and @flag1='1'
;
update coz_serve_org_gain_log t
set
takeback_flag='1'
,takeback_time=now()
,takeback_by='{curUserId}'
,takeback_type='4'
,update_by='{curUserId}'
,update_time=now()
where seorg_guid='{seorgGuid}' and not exists(select 1 from coz_serve_org_category where cattype_guid=t.cattype_guid and seorg_guid='{seorgGuid}' and del_flag='0') and @flag1='1'
;
delete from coz_serve_user_gain_valid where seorg_glog_guid in (select guid from coz_serve_org_gain_log t where seorg_guid='{seorgGuid}' and not exists(select 1 from coz_serve_org_category where cattype_guid=t.cattype_guid and seorg_guid='{seorgGuid}' and del_flag='0') and takeback_flag='1') and @flag1='1'
;
update coz_serve_user_gain_log t
set
takeback_flag='1'
,takeback_time=now()
,takeback_by='{curUserId}'
,takeback_type='4'
,update_by='{curUserId}'
,update_time=now()
where seorg_glog_guid in (select guid from coz_serve_org_gain_log t where seorg_guid='{seorgGuid}' and not exists(select 1 from coz_serve_org_category where cattype_guid=t.cattype_guid and seorg_guid='{seorgGuid}' and del_flag='0') and takeback_flag='1') and @flag1='1'
;
update coz_serve_org_category_log t2
inner join
coz_app_user_notice q1
on t2.seorg_guid=q1.create_by and t2.cattype_guid=q1.update_by
set
t2.cattype_ungrant='1'
,t2.update_by='{curUserId}'
,t2.update_time=now()
where biz_no=@biz_no and @flag1='1'
;
select user_id as seorgST1UserId,content,type as msgType from coz_app_user_notice where biz_no=@biz_no
;