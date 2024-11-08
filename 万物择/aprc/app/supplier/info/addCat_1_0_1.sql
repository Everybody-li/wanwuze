-- ##Title app-供方-添加品类
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供方-添加品类
-- ##CallType[ExSql]

-- ##input priceMode string[1] NOTNULL;品类报价模式（1：型号模式，2：按单模式），必填
-- ##input categoryGuid char[36] NOTNULL;品类guid，必填

-- ##input curUserId string[36] NOTNULL;用户id，必填


set @supplierguid=uuid()
;
INSERT INTO coz_category_supplier(guid,category_guid,user_type,user_id,user_price_mode,del_flag,create_by,create_time,update_by,update_time)
select 
@supplierguid
,'{categoryGuid}'
,'1'
,'{curUserId}'
,'{priceMode}'
,'0'
,'-1'
,now()
,'-1'
,now()
from
sys_app_user t
where 
guid='{curUserId}' and status='0' and not exists(select 1 from coz_app_user_permission where user_id=t.guid and del_flag='0' and status='0' and type='3') and
not exists(select 1 from coz_app_user_permission_detail where user_id=t.guid and del_flag='0' and biz_guid='{categoryGuid}' and type='5')
;
insert into coz_supplier_notice_setting(guid,user_id,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,'{curUserId}'
,'0'
,'1'
,now()
,'1'
,now()
from 
coz_category_supplier
where guid=@supplierguid and not exists(select 1 from coz_supplier_notice_setting where user_id='{curUserId}')