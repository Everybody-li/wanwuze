-- ##Title web-给服务机构授权品类
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-给服务机构授权品类
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input seorgGuid string[36] NOTNULL;机构专属码，必填
-- ##input categoryGuid string[36] NOTNULL;机构专属码，必填
-- ##input cattypeGuid string[36] NOTNULL;品类类型guid，必填
-- ##input batchNo string[36] NOTNULL;批量授权操作编号(前端传一个uuid)，必填

set @flag1=(select case when exists(select 1 from coz_serve_org where guid='{seorgGuid}' and del_flag='0') then '1' else '0' end)
;
set @flag2=(select case when exists(select 1 from coz_category_info where guid='{categoryGuid}' and del_flag='0') then '1' else '0' end)
;
insert into coz_serve_org_category(guid,seorg_guid,cattype_guid,category_guid,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{seorgGuid}' as seorgGuid
,'{cattypeGuid}' as cattype_guid
,'{categoryGuid}' as category_guid
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1' and @flag2='1' and not exists(select 1 from coz_serve_org_category where seorg_guid='{seorgGuid}' and cattype_guid='{cattypeGuid}'  and category_guid='{categoryGuid}' and del_flag='0')
limit 1
;
insert into coz_serve_org_category_log(guid,seorg_guid,cattype_guid,category_guid,batch_no,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{seorgGuid}' as user_name
,'{cattypeGuid}' as cattype_guid
,'{categoryGuid}' as category_guid
,'{batchNo}' as batch_no
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1' and @flag2='1' and not exists(select 1 from coz_serve_org_category_log where seorg_guid='{seorgGuid}' and cattype_guid='{cattypeGuid}'  and category_guid='{categoryGuid}' and op_type='1' and del_flag='0')
limit 1
;