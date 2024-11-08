-- ##Title 沟通模式向该招聘方保存投递等待且未取消的需求
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 沟通模式向该招聘方保存投递等待且未取消的需求
-- ##CallType[ExSql]

-- ##input recruitReimg string[1000] NOTNULL;招聘简介图片，必填
-- ##input recruitGuid char[36] NOTNULL;招聘信息guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @requestSupplyGuid=uuid()
;
set @flag1=(select case when exists(select 1 from coz_user_biz_settings where name='cderequest_auto_recommend' and value='0ff' and del_flag='0' and user_id='{curUserId}') then '0' else '1' end)
;
insert into coz_chat_demand_request_supply(guid,de_request_guid,recruit_guid,recruit_user_id,recruit_user_name,recruit_user_phone,recruit_reimg,recommend_type,send_resume_flag,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,t.guid as de_request_guid
,'{recruitGuid}' as recruit_guid
,t1.guid as recruit_user_id
,t1.user_name as recruit_user_name
,t1.phonenumber as recruit_user_phone
,'{recruitReimg}' as recruit_reimg
,'2' as recommend_type
,'2' as send_resume_flag
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,@requestSupplyGuid as update_by
,now()as update_time
from
coz_chat_demand_request t
left join
sys_app_user t1
on t1.guid='{curUserId}'
where
t.status='1' and t.send_type='2' and t.cancel_flag='1' and t.del_flag='0' and t.user_id<>'{curUserId}' and t.category_guid=(select category_guid from coz_chat_recruit where guid='{recruitGuid}') and @flag1='1'
;
insert into coz_chat_demand_request_supply_detail(guid,request_supply_guid,fd_code,fd_name,fd_value,status,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,t1.guid as request_supply_guid
,t.fd_code
,(select name from coz_model_fixed_data where guid=t.fd_guid) as fd_name
,t.fd_value
,t.status
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now()as update_time
from
coz_chat_recruit_detail t
inner join
coz_chat_demand_request_supply t1
on t1.update_by=@requestSupplyGuid
where 
t.recruit_guid='{recruitGuid}' and @flag1='1'
;

