-- ##Title 需求-查询已开启接单的app供方列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 需求-查询已开启接单的app供方列表	
-- ##CallType[QueryData]

-- ##input supplierGuid string[36] NULL;品类guid，必填
-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
t.guid
,t.user_id as userId
,t1.user_name as userName
,t1.phonenumber as userPhone
,t.range_flag as rangeFlag
,t.user_price_mode as userPriceMode
,t2.guid as noticeSettingGuid
,t2.receive_flag as receiveFlag
,t2.voice_type as voiceType
,t.accpet_order_flag as acceptOrderFlag
from
coz_category_supplier t
left join
sys_app_user t1
on t.user_id=t1.guid
left join
coz_supplier_notice_setting t2
on t2.user_id=t1.guid
where t.category_guid ='{categoryGuid}' and t.del_flag='0' and t1.status='0' and t1.del_flag='0' and not exists(select 1 from coz_app_user_permission where user_id=t.user_id and type=3 and del_flag='0' and status='1') and not exists(select 1 from coz_app_user_permission_detail where biz_guid=t.category_guid and user_id=t.user_id and type=5 and del_flag='0') and (t.guid='{supplierGuid}' or '{supplierGuid}'='')